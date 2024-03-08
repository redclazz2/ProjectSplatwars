/// @desc helper function for appending arguments together to avoid having to type "+string(var)+" all the time
/// @arg value* value to append
/// @arg ...
function logger_text() {

	var str = ""
	for (var i=0; i<argument_count; i++) {
		str += string(argument[i]);	
	}
	return str;


}
