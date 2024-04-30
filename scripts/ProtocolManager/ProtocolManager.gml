enum ProtocolManagerCommands{
	NonGroupableMessage,
}

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
	
	create_protocol = function(type,groupable = false){
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
	
	add_data_protocol = function(_id,_targets = [],_data = [],_stamp = 0){
		var protocol = ds_map_find_value(protocol_registry,_id);
		if(protocol != undefined){
			protocol.queue_data(_data,_targets,_stamp);
		}
	}
	
	notify_manager = function(command,data = undefined){
		manager.network_manager_notify(
			NetworkManagerNotificationKey.ProtocolManager,
			command,
			data
		);
	}
	
	protocol_tick = function(_protocol_manager){
		logger(LOGLEVEL.INFO,"Protocol Tick","OEPF - PROTOCOL MANAGER");
		
		var protocols = ds_map_keys_to_array(_protocol_manager.protocol_registry),
			protocol_count = array_length(protocols);
			//groupable_buffer = buffer_create(256,buffer_grow,1);
		
		for(var i = 0; i < protocol_count; i++){
			var current_protocol = ds_map_find_value(_protocol_manager.protocol_registry,protocols[i]);
			if(current_protocol.groupable){
				//TODO: Groupable Logic
			}else{
				var packet_structure = current_protocol.protocol_tick();
				if(array_length(packet_structure) > 0)
					_protocol_manager.notify_manager(
						ProtocolManagerCommands.NonGroupableMessage,
						packet_structure
					);
			}	
		}
	}
	
	destroy = function(){
		var protocols = ds_map_keys_to_array(protocol_registry);
		
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
		manager.get_network_configuration("ConfigurationTickRate"),
		time_source_units_frames,
		protocol_tick,
		[self],
		-1
	);
	
	time_source_start(protocol_clock);
}