enum CommunityManagerCommands{
	DestroyCommunity
}

function CommunityManager(_manager) constructor{
	manager = _manager;
	community_map = ds_map_create();
	active_community = -1;
	
	destroy = function(){
		if(ds_exists(community_map,ds_type_map)){
			var keys = ds_map_keys_to_array(community_map);
			
			for(var i = 0; i < array_length(keys); i++){
				destroy_community(keys[i]);
			}

			ds_map_destroy(community_map);
		}
	}
	
	register_community = function(
		_id,
		_session_key,
		_community_leader,
		_max_stations = 8,
		_current_stations = 0,
		_current_stations_data = [],
		_active = false)
	{
		if(ds_exists(community_map,ds_type_map)){
			var add_community = new Community(
				_id,
				_session_key,
				_community_leader,
				_max_stations,
				_current_stations,
				_current_stations_data
			);	
		
			ds_map_add(community_map,_id,add_community);
		
			if(_active) active_community = _id;
		}
	}
	
	notify_manager = function(_command, _data = undefined){
		manager.network_manager_notify(
			NetworkManagerNotificationKey.CommunityManager,
			_command,
			_data
		);
	}
	
	destroy_community = function(_id){
		var to_destroy = ds_map_find_value(community_map,_id);
		
		if(!is_undefined(to_destroy))
		{	
			if(to_destroy.community_leader == 
				manager.station_manager.local_station)
			
			notify_manager(
				CommunityManagerCommands.DestroyCommunity,
				to_destroy.id
			);
			
			to_destroy.destroy();
			delete to_destroy;
		}
		
		ds_map_delete(community_map,_id);
	}
	
	get_community = function(_id){
		var _return = -1;
		
		if(ds_exists(community_map,ds_type_map) && ds_map_exists(community_map,_id)){
			_return = ds_map_find_value(community_map,_id);
		}
		
		return _return;
	}
}