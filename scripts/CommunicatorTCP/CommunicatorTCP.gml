enum CommunicatorTCPNotificationCommands{
	ServerConnectionOk,
	ServerConnectionFailed,
	ServerAuthorizationOk,
	ServerAuthorizationFailed,
	ServerNoLobbyFound,
	ServerLobbyFound,
	ServerLobbyCreationOk,
	ServerLobbyCreationFailed,
}

function CommunicatorTCP(_manager):ICommunicator(_manager) constructor{
	game_server_ip = "127.0.0.1";
	game_server_port = 8057;
	debug_logger_name = "OEPF - TCP COMMUNICATOR";
	
	create = function(){
		network_set_config(network_config_connect_timeout,
			manager.get_network_configuration("ConfigurationNativeConnectionTimeout"));
		network_set_config(network_connect_nonblocking,
			manager.get_network_configuration("ConfigurationNativeBlockingSocket"));
			
		socket = network_create_socket(network_socket_tcp);
		buffer = buffer_create(512,buffer_fixed,1);
		logger(LOGLEVEL.INFO,$"Created TCP Socket",debug_logger_name);	
	}
	
	destroy = function(){
		if(buffer_exists(buffer)) buffer_delete(buffer);
		network_destroy(socket);
		logger(LOGLEVEL.INFO,"Destroyed TCP Communicator",debug_logger_name);
	}
	
	notify_manager = function(_message,_data = undefined){
		manager.network_manager_notify(
				NetworkManagerNotificationKey.CommunicatorTCP,
				_message,_data);	
	}
	
	assing_reader = function(_ip,_port,_buffer){
		var _message = buffer_read(_buffer,buffer_u16);
		
		switch(_message){
			case 0: //Server Authorization
				change_reader(new ServerAuthorizationRecieved(self));
			break;
			
			case 1: //Matchmaking Resolve
				change_reader(new ServerMatchmakeRecieved(self));
			break;
			
			case 2: //Lobby Creation Resolve
				change_reader(new ServerCreationRecieved(self));
			break;
		}
		
		reader.read(_ip,_port,_buffer);
	}
	
	initialize_connection_to_game_server = function(){
		logger(LOGLEVEL.INFO,"Attempting TCP Communication to Game Server",debug_logger_name);
		network_connect_raw_async(socket,game_server_ip,game_server_port);	
	}
	
	execute_server_authorization = function(){
		change_writer(new ServerAuthorization(self));
		writer.write();
	}
	
	execute_matchmake_request = function(){
		change_writer(new MatchmakeRequest(self));
		writer.write();
	}
	
	execute_lobby_creation = function(){
		change_writer(new LobbyCreation(self));
		writer.write();
	}
	
	execute_lobby_destruction = function(_id){
		change_writer(new LobbyDestroy(self,_id));
		writer.write();
	}
}