function AgentMainWeapon(
	_InputManager,
	_WeaponSprite,
	_ControlType,
	_Team,
	_TeamChannel,
	_Damage,
	_SpreadMin,
	_SpreadMax,
	_Range,
	_ProjectileSpeed,
	_PaintWidth,
	_PaintHeight,
	_Comsuption,
	_Special):AgentDescription(_Team,_TeamChannel) constructor{
	
	InputManager = _InputManager;
	WeaponSprite = _WeaponSprite;
	ControlType = _ControlType;
	Damage = _Damage;
	SpreadMin = _SpreadMin;
	SpreadMax = _SpreadMax;
	Range = _Range;
	ProjectileSpeed = _ProjectileSpeed;
	PaintWidth = _PaintWidth;
	PaintHeight = _paintHeight;
	Consumption = _Consumption;
	Special = _Special;
	
	Shoot_on_pressed = function(){}
	
	Shoot_pressed = function(){}
	
	Shoot_on_release = function(){}
	
	Step = function(){
		
	}
}