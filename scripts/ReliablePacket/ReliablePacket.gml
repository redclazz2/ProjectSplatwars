function ReliablePacket(_id,_target_number,_target_data,_buffer)
	:Packet(_id,_target_number,_target_data,_buffer) constructor{
	
	confirmation_map = ds_map_create();
	
	for(var i = 0; i < _target_number; i ++){
		ds_map_add(confirmation_map,_target_data[i], false);
	}
	
	set_confirmation = function(station_id){
		if(ds_map_exists(confirmation_map,station_id))
			ds_map_replace(confirmation_map,station_id,true);
	}
	
	check_recieved_by_all = function(){
		var keys = ds_map_keys_to_array(confirmation_map),
			_return = true;
		
		for(var i = 0; i < array_length(keys); i ++){
			if(!ds_map_find_value(confirmation_map,keys[i])) _return = false;
		}
		
		return _return;
	}
	
	destroy = function(){
		if(buffer_exists(buffer)) buffer_delete(buffer);
		if(ds_exists(confirmation_map,ds_type_map)) ds_map_destroy(confirmation_map);
	}
}