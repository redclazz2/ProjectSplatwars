///@description Use temp camera scripts!

var dur = 1;
var perc = 0.1;

var obj;
obj[0] = obj_player_demo;

for(var i=0;i<array_length_1d(obj);i++;){
	
	if(place_meeting(x,y,obj[i])){
	if(instance_exists(obj[i])){
		cam_bars(dur,perc);
		cam_temp_coord( 1, 0.5,0.75 );
		cam_temp_inroom(1,1);
		cam_temp_follow( follow.target,obj[i].id,1 );
		cam_temp_zoom( 0.5, 10);
	}
		end; //end for loop
}

