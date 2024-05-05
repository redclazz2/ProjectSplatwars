/*Welcome To Your New Script*/
function JoinPeerResponseSend(_communicator):IWriter(_communicator) constructor{
	write = function(){
		var buffer = communicator.buffer;
		
		if(buffer_exists(buffer)){
			buffer_seek(buffer,buffer_seek_start,0);
			buffer_write(buffer,buffer_u16,0);
			buffer_write(buffer,buffer_u16,8);
			buffer_write(buffer,buffer_u16,communicator.station_manager.local_station);
			
			var socket = self.communicator.socket;
			
			network_send_udp(socket,dIp,dP,buffer,buffer_tell(buffer));
		}
	}
}