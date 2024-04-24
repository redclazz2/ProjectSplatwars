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
    CurrentAmmo = _WeaponStats.MaxAmmo;
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
		if(ShootingEnabled && CurrentAmmo >= Consumption){
            ShootingEnabled = false;
            CurrentAmmo -= Consumption; 

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
				// Munition Logic
			if (!ParentAgent.latest_action[$ "shoot_released"] && CurrentAmmo < MaxAmmo) {
                if (!weapon_interaction) {
                    CurrentAmmo = min(MaxAmmo, CurrentAmmo + (10 * AmmoRegenRate) / room_speed);
                } else {
                    CurrentAmmo = min(MaxAmmo, CurrentAmmo + AmmoRegenRate / room_speed);
                }
            }
		}
	}
	
	Draw = function(){
		draw_sprite_ext(WeaponSprite,0,x,y,1,image_yscale,image_angle,c_white,
			ParentAgent.latest_action[$ "able_to_weapon"] ? 1 : 0.5);
		
		if(ParentAgent.input_manager.controllable_type == InputTypes.LOCAL) {
	
			bar_width = 15;
			bar_height = 2;
			var bar_x = x-9;
			var bar_y = y+15;
		    var ammo_percentage = clamp(CurrentAmmo / MaxAmmo, 0, 1);
			draw_set_color(c_maroon)
			draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
			draw_set_colour(c_white);
			draw_set_colour(c_red);
		    draw_rectangle(bar_x, bar_y, bar_x + bar_width * ammo_percentage, bar_y + bar_height, false);
		}

	}
	
	
	CleanUp = function(){
		time_source_stop(ShootingTimer);
		time_source_destroy(ShootingTimer);
		delete WeaponProyectile;
	}
}