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
	
	Shoot_pressed = function(){
		
	}
}