enum CommunicatorUDPNotificationCommands{
	CreationFailed,
	CreationOk,
	PortAuthenticationOk,
	PortAuthenticationFailed,
	NATRequestFirewallBreaker,
	NATRequestJoinRequest,
	NATHostJoinConfirmation,
	NATPeerJoinConfirmation,
}

function CommunicatorUDP(_manager):ICommunicator(_manager) constructor{
	ammount_of_connections	= 10;
	range_inferior_port		= 1024;
	range_superior_port		= 65535;	
	authentication_timer	= -1;
	authentication_attemps	= 0;
	authentication_max_attemps = 5;
	debug_logger_name = "OEPF - UDP COMMUNICATOR";
	protocol_reader = undefined;
	
	create = function(){
		var port = self.range_inferior_port;
		do{
			self.socket = network_create_server(network_socket_udp,port,self.ammount_of_connections);
			port++;
		}until(self.socket >= 0 || port > self.range_superior_port);
			
		if(self.socket < 0){
			logger(LOGLEVEL.ERROR,"Unable to bind port to UDP socket.",debug_logger_name);
			notify_manager(CommunicatorUDPNotificationCommands.CreationFailed);
		}else{
			self.port = port - 1;
			logger(LOGLEVEL.INFO,$"Created UDP Socket on port: {self.port}",debug_logger_name);	
			authentication_timer =	time_source_create(
				time_source_global,2,time_source_units_seconds,self.execute_port_authentication,[],-1);
			buffer = buffer_create(256,buffer_grow,1);
			notify_manager(CommunicatorUDPNotificationCommands.CreationOk);
		}
	}
	
	destroy = function(){
		if(time_source_exists(authentication_timer)){
			time_source_destroy(authentication_timer);
		}
		if(buffer_exists(buffer)) buffer_delete(buffer);
		network_destroy(socket);
		logger(LOGLEVEL.INFO,"Destroyed UDP Communicator",debug_logger_name);
	}
	
	notify_manager = function(_message,_data = undefined){
		manager.network_manager_notify(
				NetworkManagerNotificationKey.CommunicatorUDP,
				_message,_data);	
	}
	
	assing_reader = function(_ip,_port,_buffer){
		var _message = buffer_read(_buffer,buffer_u16);
		
		switch(_message){
			case 0: //Port Authentication
				change_reader(new PortAuthorizationRecieved(self));
			break;
			
			case 1: //Recieved Protocol Data
				change_reader(new ProtocolDataRecieved(self));
			break;
		}
		
		reader.read(_ip,_port,_buffer);
	}
	
	assign_protocol_reader = function(_ip,_port,_buffer){
		var command = buffer_read(_buffer,buffer_f32);
		switch(command){
			case ProtocolUDPCases.OEPFNatTraversal:			
				protocol_reader = new NATTraversalRecieved(self);			
			break;
		}
		
		protocol_reader.read(_ip,_port,_buffer);
	}
	
	initialize_port_authentication = function(){
		if(time_source_exists(authentication_timer)){
			time_source_start(authentication_timer);
		}
	}
	
	execute_port_authentication = function(){
		if(authentication_attemps <= authentication_max_attemps){
			change_writer(new PortAuthorization(self));
			writer.write();
			authentication_attemps++;
		}else{
			finalize_port_authentication();
			notify_manager(CommunicatorUDPNotificationCommands.PortAuthenticationFailed);
		}
	}
	
	finalize_port_authentication = function(){
		time_source_stop(authentication_timer);
	}
	
	execute_send_protocol_message = function(_packets,_is_reliable){
		change_writer(new ProtocolPacketSend(self,_packets,_is_reliable,manager.station_manager));
		writer.write();
	}

	start_join_procedure = function(community_manager,station_manager){
		var current_active_community = 
	}
}