/// @description Agent Shooter Definition

event_inherited();

shootingCooldown = self[$ "ShootingCooldown"] ?? 0;
				
shootingEnabled = true;

function shooting_cooldown_release(){
	shootingEnabled = true;
}

shootingTimer = time_source_create(
					time_source_global,
					shootingCooldown,
					time_source_units_frames,
					shooting_cooldown_release,
					[],
					1
				);
