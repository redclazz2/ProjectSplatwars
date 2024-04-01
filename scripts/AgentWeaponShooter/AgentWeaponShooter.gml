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
	gunOffSetX = _WeaponStats.WeaponOffSetX;
	gunOffSetY = _WeaponStats.WeaponOffSetX;
	gunDirection = point_direction(0,0,gunOffSetX,gunOffSetY);
	gunLength = point_distance(0,0,gunOffSetX,gunOffSetY);
	ShootingCooldown = _WeaponStats.ShootingCooldown;		
	ShootingEnabled = true;
	image_angle = 0;
	image_yscale = 1;
	x = ParentAgent.x;
	y = ParentAgent.y;

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
	
	Step = function(){
		x = ParentAgent.x;
		y = ParentAgent.y;
		
		var _input = InputManager.InputCheckAction();

		ProjectileDirection = _input[$ "aim"] ?? 0;
		
		image_angle = ProjectileDirection;
		
		if(ProjectileDirection < 270 && 
			ProjectileDirection > 90) {
			image_yscale = -1;
		}else{ 
			image_yscale = 1;
		}
		
		if(_input[$ "ShootOnPressed"] ?? false) Shoot_on_pressed();
		if(_input[$ "ShootPressed"] ?? false) Shoot_pressed();
		if(_input[$ "ShootOnReleased"] ?? false) Shoot_on_release();
	}
	
	Draw = function(){
		draw_sprite_ext(WeaponSprite,0,x,y,1,image_yscale,image_angle,c_white,1);
	}
	
	CleanUp = function(){
		time_source_stop(ShootingTimer);
		time_source_destroy(ShootingTimer);
		delete WeaponProyectile;
	}
}