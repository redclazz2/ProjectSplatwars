function UserInterfaceConnecting():UserInterfaceSquidDecored() constructor{
	title_x = room_width / 2;
	title_y = (room_height / 2) - 10;
	
	instruction_text = scribble("[fGeneralFont][fa_center]Connecting to the internet...");
	
	InitiliazeNetworking();
	
	Step = function(){
		self.SquidInstances();
	}
	
	DrawGUI = function(){
		draw_sprite_ext(sWhitePixel,0,0,title_y,320,22,0,c_black,0.6);
		instruction_text.draw(title_x,title_y);
	}
}