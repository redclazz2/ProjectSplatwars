/// @description Main Weapon Definition
event_inherited();

weapon_config = self[$ "WeaponConfig"] ?? undefined;
if(weapon_config == undefined) instance_destroy();
