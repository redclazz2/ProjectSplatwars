function MobileInputStrategy(_player_manager):IInputManagerStrategy(_player_manager) constructor{	
	InputCheckLeft = function(){
		if(input_check("left") > 0){
			return true;
		}
		return false;
	}

	InputCheckRight = function(){
		if(input_check("right") > 0){
			return true;
		}
		return false;		
	}

	InputCheckUp = function(){
		if(input_check("up") > 0){
			return true;
		}
		return false;	
	}

	InputCheckDown = function(){
		if(input_check("down") > 0){
			return true;
		}
		return false;	
	}
		
	InputCheckAimDirection = function(){	
		return point_direction(0,0,
			oInputManager.vAimStick.get_x(),
			oInputManager.vAimStick.get_y());
	}
}