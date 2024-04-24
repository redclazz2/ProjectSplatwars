function AgentMainWeapon(
	_InputManager,
	_ParentAgent,
	_ControlType, //DELETE: INPUT MANAGER ALREADY KNOWS
	_Team,
	_TeamChannel,
	_WeaponStats
	):AgentDescription(_Team,_TeamChannel) constructor{
	
	ParentAgent = _ParentAgent;
	InputManager = _InputManager;
	WeaponSprite = _WeaponStats.WeaponSprite;
	ControlType = _ControlType;
	Damage = _WeaponStats.Damage;
	SpreadMin = _WeaponStats.SpreadMin;
	SpreadMax = _WeaponStats.SpreadMax;
	Range = _WeaponStats.Range;
	ProjectileSpeed = _WeaponStats.ProjectileSpeed;
	PaintWidth = _WeaponStats.PaintWidth;
	PaintHeight = _WeaponStats.PaintHeight;
	Consumption = _WeaponStats.Consumption;
	MaxAmmo = _WeaponStats.MaxAmmo;
	AmmoRegenRate = _WeaponStats.AmmoRegenRate;
	Special = _WeaponStats.Special;
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
		ProjectileDirection
	);
	
	Shoot_on_pressed = function(){}
	
	Shoot_pressed = function(){}
	
	Shoot_on_release = function(){}
	
	Step = function(){
		x = ParentAgent.x;
		y = ParentAgent.y;
		
		var _input = InputManager.InputCheckAction();
		
		ProjectileDirection = _input[$ "aim"] ?? 0;
			
		if(_input[$ "ShootOnPressed"] ?? false) Shoot_on_pressed();
		if(_input[$ "ShootPressed"] ?? false) Shoot_pressed();
		if(_input[$ "ShootOnReleased"] ?? false) Shoot_on_release();
	}
	
	Draw = function(){}
	
	DrawGUI = function(){}

	CleanUp = function(){
		delete WeaponProyectile;
	}
}