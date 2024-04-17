function BubbleEndState(bubble):IBubbleState(bubble) constructor {
	_bubble.image_speed = 1;
	_bubble.sprite_index = BubbleFinish;
	
	Draw = function() {
		with (_bubble) draw_self();
		
	}
	
	onAnimationEnd = function() {
		with (_bubble) instance_destroy();
	}
}