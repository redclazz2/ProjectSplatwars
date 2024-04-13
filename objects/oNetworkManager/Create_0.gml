/// @description Network Configuration Definition
enum ConfigurationFrameworkTickrate{
	QuickTickrate	=	2,
	RegularTickrate =	4,
	LateTickrate	=	6
}

enum ConfigurationIPVersions{
	IPv4,
	IPv6
}

enum NetworkManagerNotificationKey{
	CommunicatorUDP,
	CommunicatorTCP,
}

network_configuration = {
	ConfigurationTickRate: ConfigurationFrameworkTickrate.RegularTickrate,
	ConfigurationIPVersion: ConfigurationIPVersions.IPv4,
	ConfigurationFrameworkVersion: "1.0.0",
	ConfigurationNativeConnectionTimeout: 4000,
	ConfigurationNativeBlockingSocket: 1
}

communicator_udp = undefined;

function get_network_configuration(property){
	return network_configuration[$ property];
}

function initialize_network_framework(){
	communicator_udp = new CommunicatorUDP(self);
	
	communicator_udp.create();
}

function destroy_network_framework(){
	if(communicator_udp != undefined){
		communicator_udp.destroy();
		delete communicator_udp;
	}
}

function read_udp_message(_ip,_port,_buffer){
	if(communicator_udp != undefined){
		communicator_udp.assing_reader(_ip,_port,_buffer);
	}
}

function network_manager_notify(source,command,data = undefined){
	switch(source){
		case NetworkManagerNotificationKey.CommunicatorUDP:
			handle_communicator_udp_notification(command,data);
		break;
	}
}

function handle_communicator_udp_notification(command,data){
	switch(command){
		case CommunicatorUDPNotificationCommands.CreationOk:
			communicator_udp.initialize_port_authentication();
		break;
		
		case CommunicatorUDPNotificationCommands.CreationFailed:
			change_manager_user_interface(new UserInterfaceCommunicationError());
			destroy_network_framework();
		break;
		
		case CommunicatorUDPNotificationCommands.PortAuthenticationOk:
			logger(LOGLEVEL.INFO,$"Authentication Completed {communicator_udp.port}","UDP");
		break;
		
		case CommunicatorUDPNotificationCommands.PortAuthenticationFailed:
			destroy_network_framework();
			change_manager_user_interface(new UserInterfaceCommunicationError());
		break;
	}
}