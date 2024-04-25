function Protocol(
	_id,
	_manager,
	_reliable = false,
	_groupable = false
) constructor{
	packet_queue = ds_priority_create();
	manager = _manager;
	reliable = _reliable;
	groupable = _groupable;
	
	data_to_buffer = function(_data){
		
	}
	
	queue_data = function(_data,_stamp){
		var _buffer = data_to_buffer(_data),
			_packet = manager.packet_manager.create_packet();
			
		
	}
	
	queue_lenght = function(){
		return ds_priority_size(packet_queue);
	}
	
	protocol_tick = function(){
		return ds_priority_delete_min(packet_queue);
	}
}