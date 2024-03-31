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

function configuration_get_paint_property(prop){
	var result = undefined;
	
	with(oGeneralManager){
		result = configuration_paint_system[$ prop] ?? undefined;
	}
	
	return result;
}

function configuration_set_paint_property(prop,value){
	with(oGeneralManager){
		if(configuration_paint_system[$ prop] != undefined)
			configuration_paint_system[$ prop] = value;
	}
}

function configuration_get_gameplay_property(prop){
	var result = undefined;
	
	with(oGeneralManager){
		result = configuration_gameplay[$ prop] ?? undefined;
	}
	
	return result;
}

function configuration_set_gameplay_property(prop,value){
	with(oGeneralManager){
		if(configuration_gameplay[$ prop] != undefined)
			configuration_gameplay[$ prop] = value;
	}
}