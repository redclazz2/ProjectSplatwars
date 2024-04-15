function BubbleInitializeState(bubble):IBubbleState(bubble) constructor {
	_bubble.image_speed = 4;
	_bubble.sprite_index = BubbleStartup;
	
	Draw = function() {
		with (_bubble) draw_self();
	}
	
	onAnimationEnd = function() {
		_bubble.changeState(new BubbleActiveState(_bubble));
	}
}
