function ControllableAgentLocalPosition(_character):IAgentControllablePosition(_character) constructor{	
	Step = function(input_map){
		var character = self.controllable_character,
			c_speed = self.controllable_character.GetActiveStat("speed_active"),
			hor = input_map[$ "Right"] - input_map[$ "Left"],
			ver = input_map[$ "Down"] - input_map[$ "Up"],
			move_dir = point_direction(0,0,hor,ver),
			xvec = 0, 
			yvec = 0,
			lay_id = layer_get_id("Walls"),
			tile_id = layer_tilemap_get_id(lay_id);

		if (abs(hor)+abs(ver) != 0) { 
			xvec = lengthdir_x(c_speed,move_dir); 
			yvec = lengthdir_y(c_speed,move_dir); 
			
			with(character){
				if !place_meeting(x + xvec,y, [tile_id]){
					x += xvec;
				}
	   
				if !place_meeting(x,y + yvec,[tile_id]){
					y += yvec;
				}
			}
			
		}
	}
}