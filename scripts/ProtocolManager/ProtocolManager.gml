function ProtocolManager(_manager) constructor{
	manager = _manager;
	protocol_registry = ds_map_create();
	packet_manager = new PacketManager(self);
	
	generate_protocol_id = function(){
		var _intended = irandom($FFFFFFFE);
		
		while(ds_map_exists(protocol_registry,_intended)){
			_intended = irandom($FFFFFFFE);
		}
		
		return _intended;
	}
	
	create_protocol = function(type,groupable){
		var _id = generate_protocol_id(),
			_protocol = undefined;
		
		switch(type){
			//Unreliable
			case 0:
				_protocol = new Protocol(_id,self,false,groupable);
			break;
			
			//Reliable
			case 1:
				_protocol = new Protocol(_id,self,true,groupable);
			break;
		}
		
		if(ds_exists(protocol_registry,ds_type_map)) 
			ds_map_add(protocol_registry,_id,_protocol);
		
		return _id;
	}	
	
	destroy_protocol = function(_id){
		if(ds_map_exists(protocol_registry,_id)){
			var current_protocol = ds_map_find_value(protocol_registry,_id);
			current_protocol.destroy();
			
			ds_map_delete(protocol_registry,_id);
		}
	}
	
	protocol_tick = function(){
		logger(LOGLEVEL.INFO,"Protocol Tick","OEPF - PROTOCOL MANAGER");
		
		//Protocol send data for individuals and groupables
	}
	
	destroy = function(){
		var protocols = ds_map_values_to_array(protocol_registry);
		
		for(var i = 0; i < array_length(protocols); i ++){
			destroy_protocol(protocols[i]);
		}
		
		if(ds_exists(protocol_registry,ds_type_map))
			ds_map_destroy(protocol_registry);
		
		if(time_source_exists(protocol_clock)){
			time_source_stop(protocol_clock);
			time_source_destroy(protocol_clock);
		}
		
		if(packet_manager != undefined){
			packet_manager.destroy();
			delete packet_manager;
			packet_manager = undefined;
		}
	}
	
	protocol_clock = time_source_create(
		time_source_global,
		get_network_configuration("ConfigurationTickRate"),
		time_source_units_frames,
		protocol_tick,
		[],
		-1
	);
	
	time_source_start(protocol_clock);
}