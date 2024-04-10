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
	gunOffSetY = _WeaponStats.WeaponOffSetY;
	gunDirection = point_direction(0,0,gunOffSetX,gunOffSetY);
	gunLength = point_distance(0,0,gunOffSetX,gunOffSetY);
	ShootingCooldown = _WeaponStats.ShootingCooldown;		
	ShootingEnabled = true;
	image_angle = 0;
	image_yscale = 1;
	x = ParentAgent.x;
	y = ParentAgent.y;
	ParentAgent.stats[$ "speed_shooting"] = 
		ParentAgent.stats[$ "speed_walking"] *
		_WeaponStats.ShootingWalkSpeedMultiplier;
	

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
			ShootingEnabled = false;
			
			var bullet_spawn_x = x + lengthdir_x(gunLength,image_angle + gunDirection * sign(image_yscale)),
				bullet_spawn_y = y + lengthdir_y(gunLength,image_angle + gunDirection * sign(image_yscale));
			
			create_projectile(WeaponProyectile,bullet_spawn_x,bullet_spawn_y,ProjectileDirection);			
			time_source_start(ShootingTimer);
		}
	}
	
	Step = function(){
		if(instance_exists(ParentAgent) && ParentAgent.listen_to_input){
			x = ParentAgent.x;
			y = ParentAgent.y;
			
			ProjectileDirection = ParentAgent.latest_action[$ "aim_direction"];
			image_angle = ProjectileDirection;
		
			if(ProjectileDirection < 270 && ProjectileDirection > 90) {
				image_yscale = -1;
			}else{ 
				image_yscale = 1;
			}
			
			var weapon_interaction = ParentAgent.latest_action[$ "able_to_weapon"];
			
			if((ParentAgent.latest_action[$ "shoot_pressed"] ?? false) 
				&& weapon_interaction) Shoot_on_pressed();
			if((ParentAgent.latest_action[$ "shoot"] ?? false)
				&& weapon_interaction) Shoot_pressed();
			if((ParentAgent.latest_action[$ "shoot_released"] ?? false)
				&& weapon_interaction) Shoot_on_release();
		}
	}
	
	Draw = function(){
		draw_sprite_ext(WeaponSprite,0,x,y,1,image_yscale,image_angle,c_white,
			ParentAgent.latest_action[$ "able_to_weapon"] ? 1 : 0.5);
	}
	
	CleanUp = function(){
		time_source_stop(ShootingTimer);
		time_source_destroy(ShootingTimer);
		delete WeaponProyectile;
	}
}