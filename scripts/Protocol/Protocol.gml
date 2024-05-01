function Protocol(
	_id,
	_manager,
	_reliable = false,
	_groupable = false
) constructor{
	id = _id;
	packet_queue = ds_priority_create();
	manager = _manager;
	reliable = _reliable;
	groupable = _groupable;
	
	data_to_buffer = function(_data){
		var new_buffer = buffer_create(256,buffer_grow,1);
		
		buffer_seek(new_buffer,buffer_seek_start,0);
		
		for(var i = 0; i < array_length(_data); i ++){
			switch(typeof(_data[i])){
				case "number":
					buffer_write(new_buffer,buffer_f32,_data[i]);
				break;
				
				case "string":
					buffer_write(new_buffer,buffer_string,_data[i]);
				break;
				
				case "bool":
					buffer_write(new_buffer,buffer_bool,_data[i]);
				break;
				
				default:
					logger(LOGLEVEL.WARN, "Trying to write data not handled to buffer.","Protocol");
				break;
			}	
		}
		
		return new_buffer;
	}
	
	queue_data = function(_data,_targets,_stamp = 0){		
		var /*_buffer = data_to_buffer(_data),*/				//Can't use since buffer copy is busted.
			_packet = manager.packet_manager.create_packet(
				array_length(_targets),
				_targets,
				_data,
				reliable
			);
		
		ds_priority_add(packet_queue,_packet,_stamp);
	}
	
	queue_lenght = function(){
		return ds_priority_size(packet_queue);
	}
	
	pop_latest_packet = function(){
		return ds_priority_delete_min(packet_queue);
	}
	
	peak_latest_packet = function(){
		return ds_priority_find_min(packet_queue);
	}
	
	protocol_tick = function(){
		var _return = [],
			_packet_id = -1,
			_packet_manager = manager.packet_manager,
			_packet_number = 0,
			_packet = undefined;
		
		if(!reliable){
			_packet_number = queue_lenght();
			array_insert(_return,array_length(_return),false);
			
			for(var i = 0; i < _packet_number; i ++){
				_packet_id = peak_latest_packet();
				_packet = _packet_manager.get_send_packet(_packet_id);
				
				if(_packet.sent){
					_packet_manager.delete_packet_from_send_registry(_packet_id);
					pop_latest_packet();
				}else{
					array_insert(_return,array_length(_return),_packet);
					_packet.sent = true;
				}
			}
		}else{			
			_packet_number = queue_lenght();
			array_insert(_return,array_length(_return),true);
			
			for(var i = 0; i < _packet_number; i ++){
				_packet_id = peak_latest_packet();
				_packet = _packet_manager.get_send_packet(_packet_id);
				
				if(_packet.check_recieved_by_all() || _packet.timeout >= 20){
					_packet_manager.delete_packet_from_send_registry(_packet_id);
					pop_latest_packet();
				}else{
					array_insert(_return,array_length(_return),_packet);
				}
			}
		}
			
		return _return;
	}

	destroy = function(){
		if(ds_exists(packet_queue,ds_type_priority))
			ds_priority_destroy(packet_queue);
	}
}