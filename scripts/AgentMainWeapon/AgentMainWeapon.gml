function AgentMainWeapon(
	_InputManager,
	_ParentAgent,
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
	
	ParentAgent = _ParentAgent;
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
	ProjectileDirection = 0;
	
	WeaponProyectile = new Projectile(
		Team,
		TeamChannel,
		Damage,
		SpreadMin,
		SpreadMax,
		Range,
		ProjectileSpeed,
		PaintWidth,
		PaintHeight,
		PaintDirection
	);
	
	Shoot_on_pressed = function(){}
	
	Shoot_pressed = function(){}
	
	Shoot_on_release = function(){}
	
	Step = function(){
		x = ParentAgent.x;
		y = ParentAgent.y;
		
		var _input = InputManager.InputCheckAction();
		
		ProjectileDirection = point_direction(x,y,
			_input[$ "aim_x"],_input[$ "aim_y"]);
			
		if(_input[$ "ShootOnPressed"]) Shoot_on_pressed();
		if(_input[$ "ShootPressed"]) Shoot_pressed();
		if(_input[$ "ShootOnReleased"]) Shoot_on_release();
	}

	CleanUp = function(){}
}