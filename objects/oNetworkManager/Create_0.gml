/// @description Network Configuration Definition
network_configuration = {
	ConfigurationTickRate: ConfigurationFrameworkTickrate.RegularTickrate,
	ConfigurationIPVersion: ConfigurationIPVersions.IPv4,
	ConfigurationFrameworkVersion: "1.0.0",
	ConfigurationNativeConnectionTimeout: 4000,
	ConfigurationNativeBlockingSocket: 1,
	ConfigurationNetworkMatchAction: NetworkMatchAction.StartMatchMaking
}

communicator_udp	= undefined;
communicator_tcp	= undefined;
station_manager		= undefined;
community_manager	= undefined;
protocol_manager	= undefined;
traversal_manager	= undefined;

function get_network_configuration(property){
	return network_configuration[$ property];
}

function initialize_network_framework(){
	station_manager = new StationManager(self);
	community_manager = new CommunityManager(self);	
	protocol_manager = new ProtocolManager(self);
	traversal_manager = new TraversalManager(self);
	
	communicator_udp = new CommunicatorUDP(self);
	communicator_udp.create();
}

function destroy_network_framework(){
	if(traversal_manager != undefined){
		traversal_manager.destroy();
		delete traversal_manager;
		traversal_manager = undefined;
	}
	
	if(community_manager != undefined){
		community_manager.destroy();
		delete community_manager;
		community_manager = undefined;
	}
	
	if(protocol_manager != undefined){
		protocol_manager.destroy();
		delete protocol_manager;
		protocol_manager = undefined;
	}
	
	if(station_manager != undefined){
		station_manager.destroy();
		delete station_manager;
		station_manager = undefined;
	}
	
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
		
		case NetworkManagerNotificationKey.CommunityManager:
			handle_community_manager_notification(command,data);
		break;
		
		case NetworkManagerNotificationKey.ProtocolManager:
			handle_protocol_manager_notification(command,data);
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
		
		case CommunicatorUDPNotificationCommands.NATRequestJoinRequest:
			logger(LOGLEVEL.INFO,"NATRequestJoinRequest","TCP-COMMUNICATOR");
			var community_id = data[0],
				community_key = data[1],
				ip = data[2],
				port = data[3],
				community = community_manager.get_community(community_id),
				current_stations_in_community = array_length(ds_map_keys_to_array(
					community.current_stations));
				
			if(community.community_leader == station_manager.local_station){
				if(community.session_key == community_key 
					&& current_stations_in_community < community.max_stations){
					//ok 
					logger(LOGLEVEL.INFO,"A join request is being proccessed by host","UDP");
					station_manager.reset_non_connected_stations_timer();
					communicator_udp.execute_host_join_response(community,station_manager,ip,port);
				}else{
					//Sorry. Can-t join. You either dont have the key or the session is full.
				}
			}else{
				//Error, im not host. Guess not responding is ok for the time i have to code this.
			}
		break;
		
		case CommunicatorUDPNotificationCommands.NATHostJoinConfirmation:
			//[community_id,community_max_stations,community_leader,community_current_stations,stations]
			var community_id = data[0],
				community_max_stations = data[1],
				community_leader =	data[2],
				leader_username	 =  data[3],
				community_current_stations = data[4],
				community_stations = data[5];
				
			//Update host ID and username
			station_manager.update_station_id(-1000,community_leader);
			var host = station_manager.get_station(community_leader);
			host.set_station_data("username",leader_username);
			host.set_station_data("connected",true);
				
			//Update Community leader
			var current_community = community_manager.get_community(community_id);
			if(current_community != -1){
				current_community.community_update_host(community_leader);
			} 
			current_community.max_stations = community_max_stations;
			station_manager.reset_non_connected_stations_timer();
			for(var i = 0; i < community_current_stations; i++){
				station_manager.register_station(
										community_stations[i][0],
										community_stations[i][1],
										community_stations[i][2],
										"Searching ...");
										
				current_community.community_update_add_station(community_stations[i][0]);
			}
			
			communicator_udp.start_joining_confirmation();
		break;
		
		case CommunicatorUDPNotificationCommands.NATPeerJoinConfirmation:
			var _id = data,
				peer = station_manager.get_station(_id);
				
			if(peer != -1){
				peer.set_station_data("connected",true);
			}
		break;
		
		case CommunicatorUDPNotificationCommands.SecurePacketConfirmation:
			var station_id = data[0],
				packet_id = data[1];
				
			packet_manager.register_reliable_confirmation(station_id,packet_id);
		break;
		
		case CommunicatorUDPNotificationCommands.NATPeerFinalizeJoin:
			var station_id = data[0],
				username = data[1],
				station = station_manager.get_station(station_id);
				
			if(station != -1){
				station.set_station_data("coonected",true);
				station.set_station_data("username",username);
			}
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
			var client_id = data[0],
				client_ip = data[1];
			
			station_manager.register_station(
										client_id,
										client_ip,
										communicator_udp.port,
										configuration_get_gameplay_property("current_local_player_username"),
										true,
										true);
		
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
		
		case CommunicatorTCPNotificationCommands.ServerLobbyFound:
			logger(LOGLEVEL.INFO,"Lobby Found. Registering host station and community","TCP");
			
			var community_id	= data[0],
				community_key	= data[1],
				host_ip			= data[2],
				host_port		= data[3];
			
			station_manager.register_station(
										-1000,
										host_ip,
										host_port,
										"");
			
			community_manager.register_community(
										community_id,
										community_key,
										-1000,
										8,
										1,
										[-1000],
										true);
										
			traversal_manager.probe_peer(
				0,
				-1000
			);
		
			communicator_tcp.execute_nat_request(5,host_ip,host_port);
		break;
		
		case CommunicatorTCPNotificationCommands.ServerLobbyCreationFailed:
			logger(LOGLEVEL.WARN,"Failed to create a lobby.","TCP");
			destroy_network_framework();
			change_manager_user_interface(new UserInterfaceCommunicationError());
		break;
		
		case CommunicatorTCPNotificationCommands.ServerLobbyCreationOk:
			logger(LOGLEVEL.INFO,$"Created Lobby:{data[0]}","TCP");
			
			community_manager.register_community(
				data[0],
				data[1],
				station_manager.local_station,
				8,
				1,
				[station_manager.local_station],
				true
			);
			
			change_manager_user_interface(new UserInterfaceLobby());
		break;
		
		case CommunicatorTCPNotificationCommands.NATFirewallBreaker:
			var _peerid = data[0],
				_probeIp = data[1],
				_probePort = data[2];
				
			station_manager.register_station(
										_peerid,
										_probeIp,
										_probePort,
										"");
			
			traversal_manager.probe_peer(
				0,
				_peerid
			);
			
			var _community = community_manager.get_community(community_manager.active_community);
			if( _community != -1){
				if(_community.community_leader == station_manager.local_station){
					//Join request
					logger(LOGLEVEL.INFO,"RECIEVED A JOIN REQUEST IM THE HOST","TCP-COMMUNICATOR");			
					_community.community_update_add_station(_peerid);
					
					//TODO: AUTO DELETE STATIONS FROM COMMUNITY
					communicator_tcp.execute_nat_request(6,_probeIp,_probePort);
					logger(LOGLEVEL.INFO,$"Ip: {_probeIp}, Port: {_probePort}","TCP-COMMUNICATOR");
				}else{
					//I'm just a peer in the world
					logger(LOGLEVEL.INFO,"RECIEVED A JOIN REQUEST IM A STATION PEER","TCP-COMMUNICATOR");		
					//communicator_tcp.execute_nat_request(7,_probeIp,_probePort);		
				}
			}
		break;
		
		//Only when host finally sends a confirmation
		case CommunicatorTCPNotificationCommands.NATJoinRequest:
			logger(LOGLEVEL.INFO,"RECIEVED A JOIN REQUEST IM THE JOINING PEER","TCP-COMMUNICATOR");
			station_manager.reset_non_connected_stations_timer();
			communicator_udp.start_join_procedure(community_manager,station_manager);
		break;
	}
}
	
function handle_protocol_manager_notification(command,data){
	switch(command){
		case ProtocolManagerCommands.NonGroupableMessage:
			var is_reliable = array_shift(data);
			communicator_udp.execute_send_protocol_message(data,is_reliable);
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
	
function handle_community_manager_notification(command,data){
	switch(command){
		case CommunityManagerCommands.DestroyCommunity:
			communicator_tcp.execute_lobby_destruction(data);
		break;
	}
}

function handle_join_other_peer_confirmation_procedure(){
	var community = community_manager.get_community(community_manager.active_community),
		stations = ds_map_keys_to_array(community.current_stations),
		connected = true;
	
	station_manager.reset_non_connected_stations_timer();
	
	for(var i = 0; i < array_length(stations); i++){
		var current_station = station_manager.get_station(stations[i]);
		
		if(current_station != -1){
			if(!current_station.get_station_data("connected")){
				traversal_manager.probe_peer(
					0,
					stations[i]
				);
				
				communicator_tcp.execute_nat_request(
					5,
					current_station.get_station_data("ip"),
					current_station.get_station_data("port"));
					
				traversal_manager.probe_peer(
					3,
					stations[i]
				);
			}
		}
	}
	//Si esta conectado ok, decile al host q estas conectado
	
	if(connected){
		logger("Connected to all stations. Sending confirmation to host ...","OEPF");
		queue_secure_message([community_manager.community_leader],[
			
			station_manager.local_station,
			configuration_get_gameplay_property("current_local_player_username")
		]);
	}
}

secure_protocol = protocol_manager.create_protocol(1,false);

queue_secure_message = function(destinations,data){
	protocol_manager.add_data_protocol(
		secure_protocol,
		destinations,
		data		
	);
}
