function JoinProcedureRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var community_id	= buffer_read(_buffer,buffer_u16),
			community_key	= buffer_read(_buffer,buffer_u16);
		
		communicator.notify_manager(
			CommunicatorUDPNotificationCommands.NATRequestJoinRequest,
			[community_id,community_key,_ip,_port]
		);
	}
}