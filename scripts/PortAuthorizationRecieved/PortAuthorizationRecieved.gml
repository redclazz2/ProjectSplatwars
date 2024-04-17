function PortAuthorizationRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		buffer_seek(_buffer,buffer_seek_start,4);
		var recieved_external_port = buffer_read(_buffer,buffer_string);
		
		communicator.port = real(recieved_external_port);
		communicator.finalize_port_authentication();
		show_debug_message(communicator.port);
		communicator.notify_manager(
			CommunicatorUDPNotificationCommands.PortAuthenticationOk
		);
	}
}