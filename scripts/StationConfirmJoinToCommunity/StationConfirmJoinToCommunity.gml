/*Welcome To Your New Script*/
function StationConfirmJoinToCommunity(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var station_id = buffer_read(_buffer,buffer_f32),
			username   = buffer_read(_buffer,buffer_string);
		
		communicator.notify_manager(
			CommunicatorUDPNotificationCommands.NATPeerFinalizeJoin,
			[station_id,username]
		);
	}
}