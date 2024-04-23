function SpecialChargeState() : IUserInterface() constructor {
	ui_event_handler = function() {};
	DrawGUI = function() {
		draw_sprite(BubbleCharge, 0, 310, 10);
		with (oPaintManager) {
			draw_text(290, 50, current_charge);
		}
	}
}
