function scene_system_goto_target(){
	with(oGeneralManager){
		scene_goto_target();
	}
}

function scene_system_set_target(scene){
	with(oGeneralManager){
		scene_set_next(scene);	    
	}
}

function scene_system_finish_transition(){
	with(oGeneralManager){
		scene_transition_finished();
	}
}