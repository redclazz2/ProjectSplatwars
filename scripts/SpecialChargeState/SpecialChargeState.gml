function SpecialChargeState() : IUserInterface() constructor {
	ui_event_handler = function() {};
	image_index = 0;
	image_speed = 1;

	Step = function() {
		var local_player = configuration_get_gameplay_property("current_local_player_instance");
		charge = 0;
		if (local_player != noone) charge = local_player.active_stats[$ "charge"];
		
		if (charge == 100) {
			current_sprite = BubbleReady;
			opacity = 0;
		}
		
		if (charge != 100) {
			current_sprite = BubbleCharge;
			opacity = 0.5;
		}
		
		percentage = charge / 4.54
		image_index = (image_index + image_speed / (game_get_speed(gamespeed_fps) / sprite_get_speed(current_sprite)) % sprite_get_number(current_sprite));
	}
	
	DrawGUI = function() {
		draw_sprite(current_sprite, image_index, 310, 10);
		draw_sprite_ext(sWhitePixel, -1, 289, 32, 21, percentage * -1, 0, c_white, opacity);
	}
}
