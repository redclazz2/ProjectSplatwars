function ProtocolPacketSend(
	_communicator,
	_packets,
	_is_reliable,
	_packet_manager,
	_station_manager
):IWriter(_communicator) constructor{
	packets = _packets;
	is_realiable = _is_reliable;
	packet_manager = _packet_manager;
	station_manager = _station_manager;
	
	write = function(){
		var buffer = communicator.buffer,
			packet_number = array_length(packets),
			destinations = {};
			
		if(buffer_exists(buffer)){			
			for(var i = 0; i < packet_number; i ++){
				buffer_seek(buffer,buffer_seek_start,1);
				buffer_write(buffer,buffer_u16,0);
				buffer_write(buffer,buffer_u16,1);
				buffer_write(buffer,buffer_bool,is_realiable);
				buffer_write(buffer,buffer_u16,packet_number);
				
				var current_packet = packet_manager.get_send_packet(packets[i]),
					src_buffer = current_packet.buffer,
					src_id = current_packet.id,
					src_target_number = current_packet.target_number,
					src_target_data = current_packet.target_data;
					
				buffer_write(buffer,buffer_u16,src_id);
				buffer_write(buffer,buffer_u16,src_target_number);
				
				for(var e = 0; e < src_target_number; e++){
					buffer_write(buffer,buffer_u16,src_target_data[e]);
					if(destinations[$ string(src_target_data[e])] == undefined)
						destinations[$ string(src_target_data[e])] = 
							station_manager.get_station(src_target_data[e]);			
				}
				
				buffer_copy(
					src_buffer,0,buffer_tell(src_buffer),
					buffer,
					buffer_seek(
						buffer,buffer_seek_relative,0
					)
				);
				
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