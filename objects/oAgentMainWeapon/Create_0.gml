/// @description Main Weapon Definition

event_inherited();

weapon_config = self[$ "WeaponConfig"] ?? undefined;
if(weapon_config == undefined) instance_destroy();

inputManager = self[$ "InputManager"] ?? undefined;

isLocal = self[$ "ControlType"] ?? false;
team = get_base_agent_property("Team");
teamChannel = get_base_agent_property("TeamChannel");
damage = self[$ "Damage"] ?? 0;;
spreadMin = self[$ "SpreadMin"] ?? 0;
spreadMax = self[$ "SpreadMax"] ?? 0;
range = self[$ "Range"] ?? 0;
pSpeed = self[$ "ProjectileSpeed"] ?? 0;
paintWidth = self[$ "PaintWidth"] ?? 0;;
paintHeight = self[$ "PaintHeight"] ?? 0;
pDirection = 0;
consumption = self[$ "Comsumption"] ?? 200;
special = self[$ "Special"] ?? undefined;

sprite_index = self[$ "WeaponSprite"] ?? plchldr_question;

weapon_proyectile = new Projectile(
	team,
	teamChannel,
	damage,
	spreadMin,
	spreadMax,
	range,
	pSpeed,
	paintWidth,
	paintHeight,
	pDirection
);

shoot_on_pressed = self[$ "Shoot_on_pressed"] ?? function(){};
shoot_pressed = self[$ "Shoot_pressed"] ?? function(){}
shoot_on_release = self[$ "Shoot_on_release"] ?? function(){}
