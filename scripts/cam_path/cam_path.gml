///@description cam_path( path, speed );
///@param path
///@param speed
function cam_path(argument0, argument1) {

	var _path = argument0;
	var _speed = argument1;

	if(instance_exists(CAM)){
		with(CAM){
			isPath = true;
			if(path_exists(_path)){
			path_start(_path,_speed,path_action_stop,true);
			}
		}
	}




}
