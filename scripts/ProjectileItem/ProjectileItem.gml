function Projectile(_team,_teamChannel,_damage, 
	_spreadmin, _spreadmax, _range, _speed,
	_paintWidth, _paintHeight,
	_direction, _is_local = false)
	:AgentDescription(_team,_teamChannel) constructor {
		
	Damage = _damage;
	Spreadmin = _spreadmin;
	Spreadmax = _spreadmax;
	Range = _range;
	Speed = _speed;
	PaintWidth = _paintWidth;
	PaintHeight = _paintHeight;
	Direction = _direction;
	isLocal = _is_local;
}