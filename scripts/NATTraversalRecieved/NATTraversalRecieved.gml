function NATTraversalRecieved(_communicator):IReader(_communicator) constructor{
	read = function(_ip,_port,_buffer){
		logger(LOGLEVEL.INFO,"Recieved NAT traversal message","UDP READER");
		var _case = buffer_read(_buffer,buffer_f32);
		
		switch(_case){
			case 0: //Firewall Breaker
				logger(LOGLEVEL.INFO,"Recieved NAT traversal Firewall Breaker","UDP PROTOCOL READER");
			break;
				
			case 1:	//Join Request
				logger(LOGLEVEL.INFO,"Recieved NAT traversal Join Request","UDP PROTOCOL READER");
			break;
			
			case 2: //Host Join Resolve
				logger(LOGLEVEL.INFO,"Recieved NAT traversal Host Join Response","UDP PROTOCOL READER");
			break;
			
			case 3: //Peer Join Confirmation
				logger(LOGLEVEL.INFO,"Recieved NAT traversal Peer Join Confirmation","UDP PROTOCOL READER");
			break;
		}
	}
}