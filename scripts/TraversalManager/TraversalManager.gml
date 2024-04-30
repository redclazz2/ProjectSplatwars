function TraversalManager(_manager) constructor{
	manager = _manager;
	protocol_id = manager.protocol_manager.create_protocol(0,false);
	
	probe_peer = function(type){
		var data = [];
		switch(type){
			case 0: //Firewall Breaker
			
			break;
				
			case 1:	//Join Request
			
			break;
			
			case 2: //Host Join Resolve
			
			break;
			
			case 3: //Peer Join Confirmation
			
			break;
		}
	}
}