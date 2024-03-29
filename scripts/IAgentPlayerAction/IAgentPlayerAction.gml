function IAgentPlayerAction(_character) constructor{
	
	controllable_character = _character;
	
	ModifySpriteDirection = function(_aimx){
		if(_aimx < controllable_character.x) controllable_character.image_xscale = -1;
		else controllable_character.image_xscale = 1;
	}
	
	Step = function(args){
		ModifySpriteDirection(args[$ "aim_x"]);
	}
	
	Draw = function(){
		draw_self();
	}
}