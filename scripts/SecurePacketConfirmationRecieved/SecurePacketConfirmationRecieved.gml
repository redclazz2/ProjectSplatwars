function SecurePacketConfirmationRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var station_id	= buffer_read(_buffer,buffer_u16),
			packet_id		= buffer_read(_buffer,buffer_u32);

		communicator.notify_manager(
			CommunicatorUDPNotificationCommands.SecurePacketConfirmation,
			[station_id,packet_id]
		);
	}
}