function ProtocolManager(_manager) constructor{
	manager = _manager;
	protocol_registry = ds_map_create();
	packet_manager = new PacketManager(self);
	
	create_protocol = function(type){
		switch(type){
			//Unreliable
			case 0:
			break;
			
			//Reliable
			case 1:
			break;
		}
	}	
	
	destroy_protocol = function(_id){
		if(ds_map_exists(protocol_registry,_id)){
			//Destroy Protocol
		}
	}
	
	protocol_tick = function(){
		logger(LOGLEVEL.INFO,"Protocol Tick","OEPF - PROTOCOL MANAGER");
	}
	
	destroy = function(){
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
	
	
	
	
}