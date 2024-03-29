/// @description Standard projectile behavior

damage = self[$ "damage"] ?? 1;
range = self[$ "range"] ?? 20;
speed = self[$ "speed"] ?? 1;
spreadmin = self[$ "spreadmin"] ?? -10;
spreadmax = self[$ "spreadmax"] ?? 20;

aimDir = point_direction(x, y, mouse_x, mouse_y);
spread = spreadmin + random(spreadmax);
direction = aimDir + spread;

function createPaint(bullet) {
	var _x = bullet.x, _y = bullet.y;
	pubsub_publish("PaintSurfaceApply", new PaintItemStructure(_x, _y, 0.25, 0.25, sSplat01, 0));
}

paintTimer = time_source_create(
	time_source_global, 
	1, 
	time_source_units_frames, 
	createPaint, 
	[self], 
	-1); 
	
time_source_start(paintTimer);