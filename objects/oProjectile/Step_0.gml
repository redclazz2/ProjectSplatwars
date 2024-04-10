/// @description Travel distance
var xspeed = lengthdir_x(_speed,image_angle),
	yspeed = lengthdir_y(_speed,image_angle),
	_dis = point_distance(xstart, ystart, x, y),
	lay_id = layer_get_id("Walls"),
	tile_id = layer_tilemap_get_id(lay_id);

x += xspeed;
y += yspeed; 

if (_dis > range || place_meeting(x,y, [tile_id])) {
	instance_destroy();
}
