function StationManager(_manager) constructor{
	manager = _manager;
	station_map = ds_map_create();
	local_station = -1;
	
	destroy = function(){
		if(ds_exists(station_map,ds_type_map)){
			ds_map_destroy(station_map);
		}
	}
	
	register_station = function(
		_id,
		_ip,
		_port,
		_username,
		_local = false)
	{
		if(ds_exists(station_map,ds_type_map)){
			var add_station = new Station(
				_id,
				_ip,
				_port,
				_username
			);	
		
			ds_map_add(station_map,_id,add_station);
		
			if(_local) local_station = _id;
		}
	}
	
	destroy_station = function(_id){
		var to_destroy = ds_map_find_value(station_map,_id);
		
		if(!is_undefined(to_destroy))
		{	
			to_destroy.destroy();
			delete to_destroy;
		}
		
		ds_map_delete(station_map,_id);
	}
	
	get_station = function(_id){
		var _return = -1;
		
		if(ds_exists(station_map,ds_type_map) && ds_map_exists(station_map,_id)){
			_return = ds_map_find_value(station_map,_id);
		}
		
		return _return;
	}
}