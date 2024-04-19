collision_rectangle_list(x-trigger_size/2,y-trigger_size/2,x+trigger_size/2,y+trigger_size/2,oAgentPlayer,false,true,Targets,true);

var _closest_target = Targets[|0] ?? self;

TargetPointX = _closest_target.x;
TargetPointY = _closest_target.y;

if(_closest_target != self && time_source_get_state(time_to_shoot) != time_source_state_active){
	time_source_start(time_to_shoot);
}else if(_closest_target == self && time_source_get_state(time_to_shoot) == time_source_state_active){
time_source_stop(time_to_shoot);
}

ds_list_clear(Targets);