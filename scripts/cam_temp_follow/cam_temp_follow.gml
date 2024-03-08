///@description cam_temp_follow( type, target, dur );
///@param type
///@param target
///@param dur
function cam_temp_follow(argument0, argument1, argument2) {

	var _type	= argument0;
	var _target = argument1;
	var _dur	= argument2;


	if ( instance_exists( CAM ))
	with( CAM ){
		if(!follow_temp){
			follow_temp  = true;
			follow_old	=  MODE[ FOLLOW ];
			target_old  = target;
		
			MODE[ FOLLOW ] = _type;
			target			= _target;
		}
		follow_timer = _dur;
	}



}
