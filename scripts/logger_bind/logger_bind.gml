/// @desc binds a value onto an existing scoped logger
/// @arg scope the scoped logger
/// @arg prop2_name* the prop name
/// @arg prop2_value* the prop value
/// @arg ...
function logger_bind() {

	var scoped_logger = argument_count > 0 and is_array(argument[0]) ? argument[0] : [];

	var j = array_length_1d(scoped_logger)
	for (var i=1; i+1<argument_count; i+=2) {
		scoped_logger[@ j+i-1] = string(argument[i]);
		scoped_logger[@ j+i] = string(argument[i+1]);
	}

	return scoped_logger;


}
