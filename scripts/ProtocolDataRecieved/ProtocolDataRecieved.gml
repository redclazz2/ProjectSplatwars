function ProtocolDataRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		var is_reliable		= buffer_read(_buffer,buffer_bool),
			packet_id		= buffer_read(_buffer,buffer_u16),
			number_targets	= buffer_read(_buffer,buffer_u16),
			targets			= {},
			station_manager = communicator.manager.station_manager;
			
		for(var i = 0; i < number_targets; i++){
			var current_target = buffer_read(_buffer,buffer_s32);
			targets[$ string(current_target)] = 0;
		}
		
		if(
			targets[$ string(station_manager.local_station)] != undefined ||
			targets[$ "-1000"] != undefined	
		){
			
			var command = buffer_read(_buffer,buffer_f32);
			switch(command){
				case ProtocolUDPCases.OEPFNatTraversal:
					logger(LOGLEVEL.INFO,"Recieved NAT traversal message","UDP READER");
					//var nat_probe_type = buffer_read()
						
				break;
			}
		}	
	}
}