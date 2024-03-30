function Projectile(_team,_teamChannel,_damage, 
	_spreadmin, _spreadmax, _range, _speed,
	_paintWidth, _paintHeight,
	_direction)
	:AgentDescription(_team,_teamChannel) constructor {
		
	damage = _damage;
	spreadmin = _spreadmin;
	spreadmax = _spreadmax;
	range = _range;
	speed = _speed;
	PaintWidth = _paintWidth;
	PaintHeight = _paintHeight;
	Direction = _direction;
}