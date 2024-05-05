function ServerNATRequestRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var type = buffer_read(_buffer,buffer_u16),
			_id = buffer_read(_buffer,buffer_u16),
			ip = buffer_read(_buffer,buffer_string),
			port = buffer_read(_buffer,buffer_u16);
		
		if(type == 5)
			result = CommunicatorTCPNotificationCommands.NATFirewallBreaker;
		else if(type == 6){
			result = CommunicatorTCPNotificationCommands.NATJoinRequest;
		}else if(type == 7){
			result = CommunicatorTCPNotificationCommands.NATPeerJoinConfirmation;
		}
		
		communicator.notify_manager(result,[_id,ip,port]);
	}
}