function create_projectile(_projectile,_x,_y,_aimx,_aimy){
	_projectile[$ "Direction"] = 
		point_direction(_x,_y,_aimx,_aimy);
	
	instance_create_layer(_x, _y, 
		"Projectile", oProjectile, _projectile);
}