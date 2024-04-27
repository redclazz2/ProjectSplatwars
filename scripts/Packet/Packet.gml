function Packet(
	_id,
	_target_number,
	_target_data,
	_buffer
) constructor{
	id = _id;
	target_number = _target_number;
	target_data = _target_data;
	buffer = _buffer;
	sent = false;
	
	destroy = function(){
		if(buffer_exists(buffer)) buffer_delete(buffer);
	}
}