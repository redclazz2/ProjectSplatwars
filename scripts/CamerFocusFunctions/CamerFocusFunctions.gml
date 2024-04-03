function CameraFocusOnTarget(_oTarget){
	global.k_set_target(_oTarget);
	if(PLATFORM_TARGET == 0) global.k_set_mode("peak_follow_target");
	else global.k_set_mode("follow_target");
}

function CameraFocusReset(){
	global.k_set_target(noone);
	global.k_set_mode("wait_mode");
}