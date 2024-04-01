function AgentWeaponShooter(
	_InputManager,
	_ControlType,
	_Team,
	_TeamChannel,
	_WeaponStats,
	_ParentAgent
):AgentMainWeapon(
	_InputManager,_ParentAgent,_ControlType,_Team,
	_TeamChannel,_WeaponStats
) constructor{
	ShootingCooldown = _WeaponStats.ShootingCooldown;		
	ShootingEnabled = true;

	Shooting_cooldown_release = function(){
		ShootingEnabled = true;
	}

	ShootingTimer = time_source_create(
						time_source_global,
						ShootingCooldown,
						time_source_units_frames,
						Shooting_cooldown_release,
						[],
						1
					);

	
	Shoot_pressed = function(){
		if(ShootingEnabled){
			create_projectile(WeaponProyectile,x,y,ProjectileDirection);
			ShootingEnabled = false;
			time_source_start(ShootingTimer);
		}
	}
	
	CleanUp = function(){
		time_source_stop(ShootingTimer);
		time_source_destroy(ShootingTimer);
		delete WeaponProyectile;
	}
}