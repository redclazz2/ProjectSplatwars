/// @desc makes a copy of a scoped logger with a new name
/// @arg old scoped logger
/// @arg new_name the new name of the logger
/// @arg prop1_name* the prop name
/// @arg prop1_value* the prop value
/// @arg ...
function logger_scoped_copy() {

	var new_logger = argument_count > 0 ? argument[0] : [];
	var new_name = argument_count > 1 ? string(argument[1]) : "default";

	new_logger[0] = new_name
	var j = array_length_1d(new_logger);
	for (var i=2; i+1<argument_count; i+=2) {
		new_logger[j++] = string(argument[i]);
		new_logger[j++] = string(argument[i+1]);
	}

	return new_logger;


}
