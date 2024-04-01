/// @description Projectile behavior test

shootKey = mouse_check_button(mb_left);

if shootKey {
	create_projectile(
	my_projectile,
	x,
	y,
	point_direction(x,y,mouse_x,mouse_y));
}




