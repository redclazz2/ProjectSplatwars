/// @description Standard Projectile Definition

event_inherited();

damage = self[$ "Damage"] ?? 1;
range = self[$ "Range"] ?? 20;
speed = self[$ "Speed"] ?? 1;
spreadmin = self[$ "Spreadmin"] ?? -10;
spreadmax = self[$ "Spreadmax"] ?? 20;
paintWidth = self[$ "PaintWidth"] ?? 0.25;
paintHeight = self[$ "PaintHeight"] ?? 0.25;
aimDir = self[$ "Direction"] ?? 0;

spread = spreadmin + random(spreadmax);
direction = aimDir + spread;

function createPaint(bullet) {
	var _x = bullet.x, 
		_y = bullet.y, 
		_channel = bullet.get_base_agent_property("TeamChannel"),
		_height = bullet.paintHeight,
		_width = bullet.paintWidth;
		
	pubsub_publish("PaintSurfaceApply", 
		new PaintItemStructure(_x, _y, _width, 
		_height, sSplat01, _channel));
}

paintTimer = time_source_create(
	time_source_global, 
	1, 
	time_source_units_frames, 
	createPaint, 
	[self], 
	-1); 
	
time_source_start(paintTimer);