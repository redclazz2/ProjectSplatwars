/// @description Projectile behavior test

shootKey = mouse_check_button(mb_left);

if shootKey {
	instance_create_layer(x, y, "Projectile", oProjectile, my_projectile);
}




