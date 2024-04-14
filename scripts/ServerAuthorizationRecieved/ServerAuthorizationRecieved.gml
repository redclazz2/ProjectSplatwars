function ServerAuthorizationRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var authorization_status = buffer_read(_buffer,buffer_u16),
			authorization_result = -1;
		
		if(authorization_status == 0)
			authorization_result = CommunicatorTCPNotificationCommands.ServerAuthorizationFailed;
		else
			authorization_result = CommunicatorTCPNotificationCommands.ServerAuthorizationOk;
		
		communicator.notify_manager(authorization_result);
	}
}