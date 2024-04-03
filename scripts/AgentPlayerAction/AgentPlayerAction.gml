function AgentPlayerAction(_character) constructor{
	controllable_character = _character;
	
	ModifySpriteDirection = function(_aim){
		if(_aim > 90 && _aim < 270){
			controllable_character.image_xscale = -1;
		}else{
			controllable_character.image_xscale = 1;
		}
	}
	
	Step = function(args){
		ModifySpriteDirection(args[$ "aim"]);
	}
	
	Draw = function(){
		draw_self();
	}
	
	DrawUI = function(){}
}