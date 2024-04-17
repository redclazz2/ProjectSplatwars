function UserInterfaceLobby():UserInterfaceSquidDecored() constructor{
	
	scribble_anim_pulse(0.2,0.05);
	instruction_text = scribble("[fGeneralFont][scale,0.8][pulse][fa_center]Waiting for players");
	gamemode_text = scribble("[fGeneralFont][fa_center][scale,0.5]RULE[scale,0.8][pulse]\nTURF WAR[/pulse][scale,0.5]\nThe team that [rainbow]\ninks more turf in \nthree minutes wins![/rainbow]");
	xx = 240;
	yy = 35;
	
	player_list = [];
	
	Step = function(){
		self.SquidInstances();
		
		if(keyboard_check_pressed(ord("E")) && array_length(player_list) < 8){
			array_insert(player_list,array_length(player_list),"Player");
		}
		
		if(keyboard_check_pressed(ord("R")) && array_length(player_list) > 0){
			array_delete(player_list,array_length(player_list) - 1,1);
		}
	}
	
	DrawGUI = function(){
		draw_sprite_ext(sWhitePixel,0,160,0,160,180,0,c_black,0.6);
		draw_sprite_ext(sWhitePixel,0,25,45,100,100,0,c_black,0.6);
		
		var player_list_lenght = array_length(player_list),
			player_drawn = 0;
		
		for(var i = 0; i < player_list_lenght; i++){
			draw_text_scribble(xx, yy + (18 * i), "[fGeneralFont][fa_center][scale,0.6]" + player_list[i]);
			player_drawn++;
		}
		
		for(var i = player_drawn; i < 8; i++){
			draw_text_scribble(xx, yy + (18 * i), "[fGeneralFont][fa_center][scale,0.6]Searching...");
		} 
		
		instruction_text.draw(240,10);
		gamemode_text.draw(75,55);
	}
}