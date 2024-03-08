/// @desc create a scoped logger
/// @arg name the name of the logger
/// @arg prop1_name* the prop name
/// @arg prop1_value* the prop value
/// @arg ...
function logger_scoped() {

	var loggername = argument_count > 0 ? string(argument[0]) : "default";

	var scoped_logger = [loggername]
	for (var i=1; i+1<argument_count; i+=2) {
		scoped_logger[@i] = string(argument[i]);
		scoped_logger[@i+1] = string(argument[i+1]);
	}

	return scoped_logger;


}
