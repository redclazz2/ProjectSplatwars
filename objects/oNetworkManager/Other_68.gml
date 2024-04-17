///Incoming Packets
var net_event_type = ds_map_find_value(async_load,"type");

try{
	switch(net_event_type){
		case network_type_data:
			var buffer = ds_map_find_value(async_load,"buffer"),
			    IncomingIP = ds_map_find_value(async_load,"ip"),
			    IncomingPort = ds_map_find_value(async_load,"port");
				
			buffer_seek(buffer,buffer_seek_start,0);
			var Identification = buffer_read(buffer,buffer_u16);
			//UDP
			if (Identification == 0){ 
				read_udp_message(IncomingIP,IncomingPort,buffer);
			//TCP
			}else if(Identification == 1){ 
				read_tcp_message(IncomingIP,IncomingPort,buffer);
			}
		break;
	
		case network_type_non_blocking_connect:
			var succeeded = ds_map_find_value(async_load, "succeeded");
			if (succeeded == 0) 
				network_manager_notify(
					NetworkManagerNotificationKey.CommunicatorTCP,
					CommunicatorTCPNotificationCommands.ServerConnectionFailed
				);
			else if (succeeded == 1) 
				network_manager_notify(
					NetworkManagerNotificationKey.CommunicatorTCP,
					CommunicatorTCPNotificationCommands.ServerConnectionOk
				);	
		break;
	}
}catch(e){
	logger(LOGLEVEL.ERROR,$"Error when reading incoming network event. Is message correctly formatted?: {e.longMessage}","Async Networking: GML Event");
}