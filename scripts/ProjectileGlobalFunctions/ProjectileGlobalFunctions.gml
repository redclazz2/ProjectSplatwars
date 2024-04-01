function create_projectile(_projectile,_x,_y,_direction){
	_projectile[$ "Direction"] = _direction;
	
	instance_create_layer(_x, _y, 
		"Projectile", oProjectile, _projectile);
}