function AgentPlayerDeath(_character):AgentPlayerAction(_character) constructor{
	self.controllable_character.sprite_index = sPlayerDeath;
	
	//Definición del tamaño de la pantalla
	x_screen = 320;
	y_screen = 180;	
	
	//Título de muerte
	death_text =  scribble("[fGeneralFont][fa_center][c_red]ANNIHILATED");
	
	//Título de respawn
	subtitle_text =  scribble("[fSubtitleFont][fa_center][rainbow]Respawn in...[/rainbow]");
	DrawGUI = function(){
	
	
	
	death_text.draw(x_screen/2,y_screen-165);
	
	draw_sprite_ext(sWhitePixel,0,0,0,320,180,0,c_black,0.6);
	}
}