/// @description Network Configuration Definition
network_configuration = {
	ConfigurationTickRate: ConfigurationFrameworkTickrate.RegularTickrate,
	ConfigurationIPVersion: ConfigurationIPVersions.IPv4,
	ConfigurationFrameworkVersion: "1.0.0",
	ConfigurationNativeConnectionTimeout: 4000,
	ConfigurationNativeBlockingSocket: 1,
	ConfigurationNetworkMatchAction: NetworkMatchAction.StartMatchMaking
}

communicator_udp = undefined;
communicator_tcp = undefined;
station_manager = undefined;
community_manager = undefined;

function get_network_configuration(property){
	return network_configuration[$ property];
}

function initialize_network_framework(){
	station_manager = new StationManager(self);
	community_manager = new CommunityManager(self);
	
	communicator_udp = new CommunicatorUDP(self);
	communicator_udp.create();
}

function destroy_network_framework(){
	if(communicator_udp != undefined){
		communicator_udp.destroy();
		delete communicator_udp;
		communicator_udp = undefined;
	}
	
	if(communicator_tcp != undefined){
		communicator_tcp.destroy();
		delete communicator_tcp;
		communicator_tcp = undefined;
	}
}

function read_udp_message(_ip,_port,_buffer){
	if(communicator_udp != undefined){
		communicator_udp.assing_reader(_ip,_port,_buffer);
	}
}

function read_tcp_message(_ip,_port,_buffer){
	if(communicator_tcp != undefined){
		communicator_tcp.assing_reader(_ip,_port,_buffer);
	}
}

function network_manager_notify(source,command,data = undefined){
	switch(source){
		case NetworkManagerNotificationKey.CommunicatorUDP:
			handle_communicator_udp_notification(command,data);
		break;
		
		case NetworkManagerNotificationKey.CommunicatorTCP:
			handle_communicator_tcp_notification(command,data);
		break;
		
		case NetworkManagerNotificationKey.External:
			handle_external_notification(command,data);
		break;
	}
}

function handle_communicator_udp_notification(command,data){
	switch(command){
		case CommunicatorUDPNotificationCommands.CreationOk:
			communicator_udp.initialize_port_authentication();
		break;
		
		case CommunicatorUDPNotificationCommands.CreationFailed:		
			destroy_network_framework();
			change_manager_user_interface(new UserInterfaceCommunicationError());
		break;
		
		case CommunicatorUDPNotificationCommands.PortAuthenticationOk:
			logger(LOGLEVEL.INFO,$"Authentication Completed {communicator_udp.port}","UDP");
			communicator_tcp = new CommunicatorTCP(self);
			communicator_tcp.create();
			communicator_tcp.initialize_connection_to_game_server();
		break;
		
		case CommunicatorUDPNotificationCommands.PortAuthenticationFailed:
			destroy_network_framework();
			change_manager_user_interface(new UserInterfaceCommunicationError());
		break;
	}
}

function handle_communicator_tcp_notification(command,data){
	switch(command){
		case CommunicatorTCPNotificationCommands.ServerConnectionFailed:
			destroy_network_framework();
			change_manager_user_interface(new UserInterfaceCommunicationError());
		break;
		
		case CommunicatorTCPNotificationCommands.ServerConnectionOk:		
			communicator_tcp.execute_server_authorization();
		break;
		
		case CommunicatorTCPNotificationCommands.ServerAuthorizationOk:
			scene_system_set_target(8);
			scene_system_goto_next();
		break;
		
		case CommunicatorTCPNotificationCommands.ServerAuthorizationFailed:
			logger(LOGLEVEL.WARN,"Server Authentication Failed.","TCP");
			destroy_network_framework();
			change_manager_user_interface(new UserInterfaceCommunicationError());
		break;
		
		case CommunicatorTCPNotificationCommands.ServerNoLobbyFound:
			logger(LOGLEVEL.INFO,"Unable to find a match.","TCP");
			communicator_tcp.execute_lobby_creation();
		break;
		
		case CommunicatorTCPNotificationCommands.ServerLobbyCreationFailed:
			logger(LOGLEVEL.WARN,"Failed to create a lobby.","TCP");
			destroy_network_framework();
			change_manager_user_interface(new UserInterfaceCommunicationError());
		break;
		
		case CommunicatorTCPNotificationCommands.ServerLobbyCreationOk:
			logger(LOGLEVEL.INFO,$"Created Lobby:{data}","TCP");
			change_manager_user_interface(new UserInterfaceLobby());
		break;
	}
}
	
function handle_external_notification(command,data){
	switch(command){
		case NetworkMatchAction.StartMatchMaking:
			communicator_tcp.execute_matchmake_request();
		break;
	}
}