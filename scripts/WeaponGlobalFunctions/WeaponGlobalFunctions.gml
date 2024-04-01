function generate_weapon(weaponIndex){
	switch(weaponIndex){
		case WeaponTypes.RegularShooter01:
			return new RegularShooter01();
		break;
	}
}