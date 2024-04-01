function AgentWeaponShooter(
	_InputManager,_ControlType,
	_Team,_TeamChannel,
	_Damage,_SpreadMin,
	_SpreadMax,_Range,
	_ProjectileSpeed,_PaintWidth,
	_PaintHeight,_Comsuption,_Special,
	_ShootingCooldown
):AgentMainWeapon(
	_InputManager,_ControlType,_Team,
	_TeamChannel,_Damage,
	_SpreadMin,_SpreadMax,
	_Range,_ProjectileSpeed,
	_PaintWidth,_PaintHeight,
	_Comsuption,_Special
) constructor{
	ShootingCooldown = _ShootingCooldown;		
	ShootingEnabled = true;

	Shooting_cooldown_release = function(){
		ShootingEnabled = true;
	}

	ShootingTimer = time_source_create(
						time_source_global,
						shootingCooldown,
						time_source_units_frames,
						shooting_cooldown_release,
						[],
						1
					);

	
	Shoot_pressed = function(){
		if(ShootingEnabled){
			create_projectile(WeaponProyectile,ProjectileDirection);
			ShootingEnabled = false;
			time_source_start(ShootingTimer);
		}
	}
	
	CleanUp = function(){
		time_source_stop(ShootingTimer);
		time_source_destroy(ShootingTimer);
	}
}