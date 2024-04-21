function Station(_id,_ip,_port,_username) constructor{
	station_data = {
		id : _id,
		ip : _ip,
		port : _port,
		username : _username	
	};
	
	get_station_data = function(_value){
		return station_data[$ _value] ?? undefined;
	}
	
	set_station_data = function(_value,_data){
		station_data[$ _value] = _data;	
	}
	
	destroy = function(){
		delete station_data;
	}
}