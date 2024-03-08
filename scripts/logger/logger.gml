/// @desc logger for use with UDP-enabled log4j loggers like Logbert,
/// @author Meseta
/// @arg level Log level
/// @arg message The log message to send
/// @arg logger_name* the logger name
/// @arg prop1_name* the prop name
/// @arg prop1_value* the prop value
/// @arg ...
function logger() {

	// self start log level
	if (not variable_global_exists("logger_level_d92e137f5ebb170c9c2f0c3dcebee238")) {
		variable_global_set("logger_level_d92e137f5ebb170c9c2f0c3dcebee238", debug_mode ? LOGLEVEL.ALL : LOGLEVEL.DEBUG); 
	}
	var minlevel = variable_global_get("logger_level_d92e137f5ebb170c9c2f0c3dcebee238");

	// get incoming log level, early return if it's too low
	var loglevel = argument_count > 0 ? argument[0] : LOGLEVEL.TRACE;
	if (loglevel < minlevel) return;

	// get the log message
	var logmessage = argument_count > 1 ? string(argument[1]) : "";

	// the logname is either a string, or comes from the scoped logger
	var scope = argument_count > 2 ? argument[2] : "default";
	var extraargs = [];
	if (is_array(scope)) {
		var loggername = string(scope[0]);
	
		// fetch extra args
		var len = floor((array_length_1d(scope)-1)/2)*2
		array_copy(extraargs, 0, scope, 1, len)
	}
	else {
		var loggername = string(scope)
	}

	// grab the rest of the extra args
	var extralen = array_length_1d(extraargs);
	for (var i=3; i+1<argument_count; i+=2) { // I don't think you can array_copy from argument
		extraargs[extralen++] = argument[i];
		extraargs[extralen++] = argument[i+1];
	}
	var echoargs = (argument_count > i) ? argument[i] : false; // secret argument! list argument is whether to echo extra parameters in name or not

	// get loglevel text
	switch(loglevel) {
		default:
		case LOGLEVEL.TRACE: var leveltxt = "TRACE"; break;
		case LOGLEVEL.DEBUG: var leveltxt = "DEBUG"; break;
		case LOGLEVEL.INFO:  var leveltxt = "INFO";  break;
		case LOGLEVEL.WARN:  var leveltxt = "WARN";  break;
		case LOGLEVEL.ERROR: var leveltxt = "ERROR"; break;
		case LOGLEVEL.FATAL: var leveltxt = "FATAL"; break;
	}

	// get unix time
	var timetxt = string_format((date_current_datetime() - 25569) * 86400, 0, 3); // to string containing unix time, 3 decimal places

	// process call stack
	var _method = "";
	if (1) {
		var callstack = debug_get_callstack();
		var _method = callstack[1]; // 1st item should be the thing that called logger
	}

	// make debug string
	var debugstr = "["+timetxt+" "+loggername+"] "+leveltxt+": "+logmessage;

	// extra props come in pairs
	var xmlpropstr = "";
	var extrastr = " { ";
	for (var i=0; i<extralen; i+=2) {
		var name = string_replace_all(string(extraargs[i]), @'"', "&quot;");
		var value = string_replace_all(string(extraargs[i+1]), @'"', "&quot;");
		xmlpropstr += @'<log4j:data name="'+name+@'" value="'+value+@'" />';
		extrastr += (i>0?", ":"")+string(extraargs[i])+": "+string(extraargs[i+1]);
	}
	extrastr += " }";

	if (extralen > 0) {
		debugstr += extrastr;
		if (echoargs) {
			logmessage += extrastr;
		}
	}

	show_debug_message(debugstr);

	// sanitize various things
	logmessage = string_replace_all(string_replace_all(logmessage, ">", "&gt;"), "<", "&lt;");
	loggername = string_replace_all(loggername, @'"', "&quot;");

	var str = @'<log4j:event logger="'+loggername+@'" timestamp="'+timetxt+@'" level="'+leveltxt+@'" thread="[main]">
	<log4j:message>'+logmessage+@'</log4j:message>
	<log4j:locationInfo method="'+_method+@'" class="" file="" />
	<log4j:properties>'+xmlpropstr+@'</log4j:properties>
	</log4j:event>
	';

	// self-start. We use this to set a global variable of the socket that is hopefully doesn't collide with any existing variables
	// also, setting it this way makes sure the variable doesn't show up in autocomplete
	if (not variable_global_exists("logger_socket_d92e137f5ebb170c9c2f0c3dcebee238")) {
		variable_global_set("logger_socket_d92e137f5ebb170c9c2f0c3dcebee238", network_create_socket(network_socket_udp)); 
	}
	var socket = variable_global_get("logger_socket_d92e137f5ebb170c9c2f0c3dcebee238");

	var len = string_byte_length(str);
	var buff = buffer_create(len, buffer_fixed, 1);
	buffer_write(buff, buffer_text, str);
	network_send_udp_raw(socket, "127.0.0.1", 7071, buff, len);
	buffer_delete(buff);

	enum LOGLEVEL {
		ALL,
		TRACE,
		DEBUG,
		INFO,
		WARN,
		ERROR,
		FATAL,
		NONE
	}


}
