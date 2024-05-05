/*Welcome To Your New Script*/
function SecurePacketConfirmationSend(_id,_communicator):IWriter(_communicator) constructor{
	packet_id = _id;
	
	write = function(){
		var buffer = communicator.buffer;
		
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,0);
			buffer_write(buffer,buffer_u16,9);
			buffer_write(buffer,buffer_u16,communicator.station_manager.local_station);
			buffer_write(buffer,buffer_u32,packet_id);
			
			var socket = self.communicator.socket;
			
			network_send_udp(socket,dIp,dP,buffer,buffer_tell(buffer));
		}
	}
}