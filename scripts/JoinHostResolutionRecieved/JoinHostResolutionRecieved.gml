function JoinHostResolutionRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var community_id				= buffer_read(_buffer,buffer_u16),
			community_max_stations		= buffer_read(_buffer,buffer_u16),
			community_leader			= buffer_read(_buffer,buffer_u16),
			leader_username				= buffer_read(_buffer,buffer_string),
			community_current_stations  = buffer_read(_buffer,buffer_u16),
			stations					= [];
		
		for(var i = 0; i < community_current_stations; i ++){
			var _id		= buffer_read(_buffer,buffer_u16),
				ip		= buffer_read(_buffer,buffer_string),
				port	= buffer_read(_buffer,buffer_u16);
				
			array_push(stations,[_id,ip,port]);
		}
		
		communicator.notify_manager(
			CommunicatorUDPNotificationCommands.NATHostJoinConfirmation,
			[community_id,community_max_stations,community_leader,leader_username,community_current_stations,stations]
		);
	}
}