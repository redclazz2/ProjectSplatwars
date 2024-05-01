function ProtocolPacketSend(
	_communicator,
	_packets,
	_is_reliable,
	_station_manager
):IWriter(_communicator) constructor{
	packets = _packets;
	is_realiable = _is_reliable;
	station_manager = _station_manager;
	
	write = function(){
		var buffer = communicator.buffer,
			packet_number = array_length(packets),
			destinations = {},
			regular_header_size = (2 * buffer_sizeof(buffer_u16)) + buffer_sizeof(buffer_bool);
			
		if(buffer_exists(buffer)){			
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,0);	//UDP Identificator
			buffer_write(buffer,buffer_u16,1);	// protocol identification
			buffer_write(buffer,buffer_bool,is_realiable);
			//buffer_write(buffer,buffer_u16,packet_number);
			
			for(var i = 0; i < packet_number; i ++){
				var current_packet = packets[i],
					src_buffer = current_packet.buffer,
					src_id = current_packet.id,
					src_target_number = current_packet.target_number,
					src_target_data = current_packet.target_data;
					
				buffer_write(buffer,buffer_u16,src_id); //Packet id
				buffer_write(buffer,buffer_u16,src_target_number); //# Of destinations
				
				for(var e = 0; e < src_target_number; e++){				// e buffer_u16
					buffer_write(buffer,buffer_s32,src_target_data[e]);
					if(destinations[$ string(src_target_data[e])] == undefined)
						destinations[$ string(src_target_data[e])] = 
							station_manager.get_station(src_target_data[e]);
				}
				
				for(var i = 0; i < array_length(src_buffer); i ++){
					switch(typeof(src_buffer[i])){
						case "number":
							buffer_write(buffer,buffer_f32,src_buffer[i]);
						break;
				
						case "string":
							buffer_write(buffer,buffer_string,src_buffer[i]);
						break;
				
						case "bool":
							buffer_write(buffer,buffer_bool,src_buffer[i]);
						break;
				
						default:
							logger(LOGLEVEL.WARN, "Trying to write data not handled to buffer.","UDP Protocol Writer");
						break;
					}	
				}
				
				var socket = self.communicator.socket,
					destination_ids = variable_struct_get_names(destinations),
					destination_number = array_length(destination_ids);
			
				for(var i = 0; i < destination_number; i ++){
					var current_destination = destinations[$ destination_ids[i]],
						current_destination_ip = current_destination.get_station_data("ip"),
						current_destination_port = current_destination.get_station_data("port");
					
					network_send_udp(
						socket,current_destination_ip,current_destination_port,buffer,buffer_tell(buffer));			
				}
			}
		}
	}
}