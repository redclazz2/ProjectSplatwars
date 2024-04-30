function TraversalManager(_manager) constructor{
	manager = _manager;
	protocol_id = manager.protocol_manager.create_protocol(0,false);
	
	destroy = function(){
		manager.protocol_manager.destroy_protocol(protocol_id);
	}
	
	probe_peer = function(type,_destination){
		var data = [];
		switch(type){
			case 0: //Firewall Breaker
				data = [0]; //Command 0
			break;
				
			case 1:	//Join Request
				data = [1]; //Command 1
			break;
			
			case 2: //Host Join Resolve
				data = [2]; //Command 2
			break;
			
			case 3: //Peer Join Confirmation
				data = [3]; //Command 3
			break;
		}
		
		manager.protocol_manager.add_data_protocol(
			protocol_id,
			[_destination],
			data		
		);
	}
}