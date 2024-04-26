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
		
		for(var i = 0; i < array_length(_data); i ++){
			switch(typeof(_data[i])){
				case "number":
					buffer_write(new_buffer,buffer_f64,_data[i]);
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
	
	queue_data = function(_data,_targets,_stamp){		
		var _buffer = data_to_buffer(_data),
			_packet = manager.packet_manager.create_packet(
				array_length(_targets),
				_targets,
				_buffer,
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
		var _return = undefined;
		
		if(!reliable){
			_return = pop_latest_packet();
		}else{
			_return = peak_latest_packet();
		}
			
		return _return;
	}

	destroy = function(){
		if(ds_exists(packet_queue,ds_type_priority))
			ds_priority_destroy(packet_queue);
	}
}