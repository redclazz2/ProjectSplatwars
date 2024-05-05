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
	
function GetActiveCommunity(){
	with(oNetworkManager){
		return community_manager.get_community(
			community_manager.active_community);
	}
}

function GetStationData(_id){
	with(oNetworkManager){
		return station_manager.get_station(_id);
	}
}

function QueueSecurePacket(destinations,data){
	with(oNetworkManager){
		queue_secure_message(destinations,data);
	}
}

function QueueUnreliablePacket(){
	with(oNetworkManager){
		
	}
}