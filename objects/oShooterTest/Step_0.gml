/// @description Projectile behavior test

shootKey = mouse_check_button(mb_left);

if shootKey {
	instance_create_layer(x, y, "Projectile", oProjectile, 
	new Projectile(
		AgentTeamTypes.ALPHA, 
		AgentTeamChannelTypes.ALPHA,
		20, -10, 10,20,5,0.5,0.5,
		point_direction(x,y,mouse_x,mouse_y)
		)
	);
}




