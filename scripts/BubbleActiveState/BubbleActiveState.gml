function BubbleActiveState(bubble):IBubbleState(bubble) constructor {
	_bubble.image_speed = 1;
	_bubble.sprite_index = BubbleActive;
	
	Draw = function() {
		with (_bubble) draw_self();
	}
	
	onProjectileCollision = function(_other) {
		var bubbleTeam = _bubble.get_base_agent_property("Team"),
			projectileTeam = _other.get_base_agent_property("Team");
		
		if (bubbleTeam != projectileTeam) {
			with(_other) instance_destroy();
		}
	}
	
	CleanUp = function() {
		time_source_stop(bubbleTimer);
		time_source_destroy(bubbleTimer);
	}
	
	onBubbleExpire = function(_bubble) {
		_bubble.changeState(new BubbleEndState(_bubble));
	}
	
	bubbleTimer = time_source_create(
		time_source_global, 
		10, 
		time_source_units_seconds, 
		onBubbleExpire, 
		[_bubble]
	);
	
	time_source_start(bubbleTimer);
}