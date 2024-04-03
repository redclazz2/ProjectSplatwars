/// @description Travel distance
var xspeed = lengthdir_x(_speed,image_angle),
	yspeed = lengthdir_y(_speed,image_angle),
	_dis = point_distance(xstart, ystart, x, y);

x += xspeed;
y += yspeed; 

if _dis > range {
	instance_destroy();
}
