function JoinHostResolutionSend(_community,_station_manager,_communicator,_dIp,_dP):IWriter(_communicator) constructor{
	community = _community;
	station_manager = _station_manager;
	dIp = _dIp;
	dP = _dP;
	
	write = function(){
		var buffer = communicator.buffer,
			community_station_keys = ds_map_keys_to_array(community.current_stations);
		
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,0);
			buffer_write(buffer,buffer_u16,7);
			buffer_write(buffer,buffer_u16,community.id);
			buffer_write(buffer,buffer_u16,community.max_stations);
			buffer_write(buffer,buffer_u16,array_length(community_station_keys));
			
			for(var i = 0; i < array_length(community_station_keys); i++){
				var current_station = station_manager.get_station(community_station_keys[i]);
				
				if(current_station != -1){
					buffer_write(buffer,buffer_u16,current_station.get_station_data("id"));
					buffer_write(buffer,buffer_u16,current_station.get_station_data("ip"));
					buffer_write(buffer,buffer_u16,current_station.get_station_data("port"));
				}	
			}
			
			var socket = self.communicator.socket;
			
			network_send_udp(socket,dIp,dP,buffer,buffer_tell(buffer));
		}
	}
}