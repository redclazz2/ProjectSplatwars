function Community(
	_id,
	_session_key,
	_community_leader,
	_max_stations = 8,
	_current_stations = 0,
	_current_stations_data = []
)constructor{
	id = _id;
	session_key = _session_key;
	community_leader = _community_leader;
	max_stations = _max_stations;
	current_stations = ds_map_create();
	
	community_has_station = function(_id){
		return ds_map_find_value(current_stations,_id);
	}
		
	community_update_add_station = function(_id){
		ds_map_add(current_stations,_id,0);
	}
	
	community_update_delete_station = function(_id){
		ds_map_delete(current_stations,_id)
	}
	
	community_update_host = function(_new){	
		ds_map_delete(current_stations,community_leader);
		community_leader = _new;
		community_update_add_station(_new);
	}
	
	destroy = function(){
		if(ds_exists(current_stations,ds_type_map)){
			ds_map_destroy(current_stations);
		}
	}
	
	for(var i = 0; i < array_length(_current_stations_data); i++){
		community_update_add_station(_current_stations_data[i]);
	}
}

