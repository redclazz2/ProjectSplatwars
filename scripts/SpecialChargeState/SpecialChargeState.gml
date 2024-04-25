function SpecialChargeState() : IUserInterface() constructor {
	ui_event_handler = function() {};
	DrawGUI = function() {
		draw_sprite(BubbleCharge, 0, 310, 10);
		with (oAgentPlayer) {
			draw_text(270, 50, active_stats[$ "charge"]);  // TODO: Make sure this is local (it's not)
		}
	}
}
