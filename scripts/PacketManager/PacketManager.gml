function PacketManager(_manager) constructor{
	manager = _manager;
	
	send_packet_registry = ds_map_create();
	sent_packet_registry = ds_map_create();
	recieved_packet_registry = ds_map_create();
	
	generate_packet_id = function(){
		/*
			This will return random integers from 0 to 4,294,967,294. 
			The value is in range for transportation in the buffer type buffer_u32
			and it is in range for the irandom function that has an upper limit of 9,223,372,036,854,775,807.
			
			If needed the value can be xpanded from FFFFFFFE to 7FFFFFFFFFFFFFFE.
			Making the max id possible: 9223372036854775806 one digit below the function's limits
			and ready for transport in buffer type buffer_u64.
		*/
		var _intended = irandom($FFFFFFFE);
		
		while(get_sent_packet(_id) || get_send_packet(_id) != undefined){
			_intended = irandom($FFFFFFFE);
		}
		
		return _intended;
	}
	
	create_packet = function(_target_number,_target_data,_buffer,_reliable = false){
		var _id = generate_packet_id(),
			_packet = undefined;
		
		if(_reliable)
			_packet = new ReliablePacket(_id,_target_number,_target_data,_buffer);
		else
			_packet = new Packet(_id,_target_number,_target_data,_buffer);
			
		return _id;
	}
	
	register_recieved_packet = function(packet_id){
		ds_map_add(recieved_packet_registry,packet_id,0);
	}
	
	register_sent_packet = function(packet_id){
		ds_map_add(sent_packet_registry,packet_id,0);
	}
	
	register_reliable_confirmation = function(station_id,packet_id){
		var packet = get_send_packet(packet_id);
		packet.set_confirmation(station_id);
	}
	
	//Returns true or false
	get_sent_packet = function(packet_id){
		return ds_map_exists(sent_packet_registry,packet_id);
	}
	
	//Returns true or false
	get_recieved_packet = function(packet_id){
		return ds_map_exists(recieved_packet_registry,packet_id);
	}
	
	//Returns packet or undefined
	get_send_packet = function(packet_id){
		return ds_map_find_value(send_packet_registry,packet_id);
	}
	
	delete_packet_from_send_registry = function(packet_id){
		var current_packet = get_send_packet(packet_id);
		
		if(current_packet != undefined){ //Packet exists
			ds_map_delete(send_packet_registry,packet_id); //Delete from send
			register_sent_packet(packet_id); //Move to sent
			
			current_packet.destroy();
		}	
	}
	
	clear_send_registry = function(){
		var packets = ds_map_keys_to_array(send_packet_registry);
		
		for(var i = 0; i < array_length(packets); i++){
			var packet = ds_map_find_value(send_packet_registry,packets[i]);
			packet.destroy();
		}
		
		ds_map_clear(send_packet_registry);
	}
	
	clear_sent_registry = function(){
		ds_map_clear(sent_packet_registry);
	}
	
	clear_recieved_registry = function(){
		ds_map_clear(recieved_packet_registry);
	}
	
	clear_all_registry = function(){
		clear_send_registry();
		clear_sent_registry();
		clear_recieved_registry();
	}
	
	destroy = function(){
		clear_all_registry();
		if(ds_exists(send_packet_registry,ds_type_map)) ds_map_destroy(send_packet_registry);
		if(ds_exists(sent_packet_registry,ds_type_map)) ds_map_destroy(sent_packet_registry);
		if(ds_exists(recieved_packet_registry,ds_type_map)) ds_map_destroy(recieved_packet_registry);
	}
}