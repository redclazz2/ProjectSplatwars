function InitiliazeNetworking(){
	with(oNetworkManager){
		initialize_network_framework();
	}
}

function InitializeMatchmaking(){
	with(oNetworkManager){
		handle_external_notification(NetworkMatchAction.StartMatchMaking);
	}
}

function SendRoomCreation(){
	with(oNetworkManager){
		
	}
}