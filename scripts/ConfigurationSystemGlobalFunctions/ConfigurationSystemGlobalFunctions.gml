function configuration_get_property(prop){
	var result = undefined;
	
	with(oGeneralManager){
		result = configuration_general[$ prop] ?? undefined;
	}
	
	return result;
}

function configuration_set_property(prop,value){
	with(oGeneralManager){
		if(configuration_general[$ prop] != undefined)
			configuration_general[$ prop] = value;
	}
}