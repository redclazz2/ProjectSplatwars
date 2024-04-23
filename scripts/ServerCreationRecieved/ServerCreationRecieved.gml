function ServerCreationRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var status = buffer_read(_buffer,buffer_u16),
			result = -1,
			lobbyId = -1,
			lobbyKey = -1;
		
		if(status == 0)
			result = CommunicatorTCPNotificationCommands.ServerLobbyCreationFailed;
		else{
			result = CommunicatorTCPNotificationCommands.ServerLobbyCreationOk;
			lobbyId	= buffer_read(_buffer,buffer_u16); 
			lobbyKey = buffer_read(_buffer,buffer_u16);
		}
			
		communicator.notify_manager(result,[lobbyId,lobbyKey]);
	}
}