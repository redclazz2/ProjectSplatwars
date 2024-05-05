function JoinPeerResponseRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var confirmed_peer = buffer_read(_buffer,buffer_u16);
				
		communicator.notify_manager(
			CommunicatorUDPNotificationCommands.NATPeerJoinConfirmation,
			confirmed_peer
		);
	}
}