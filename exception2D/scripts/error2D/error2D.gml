// Hijack the exception handler
exception_unhandled_handler(function(ex) { __exception_handler(ex); });

// Records time and date of the log, plus
function __time_string() {
	var str = "";
	var date = date_current_datetime();
	var seperator = "-"; // Seperator to use between units
	
	str += string(date_get_day(date)) + seperator + string(date_get_month(date)) + seperator + string(date_get_year(date)) + seperator + seperator + seperator + string(date_get_hour(date)) + seperator + string(date_get_minute(date)) +seperator + string(date_get_second(date));
	
	return str;	
}

// Execption handler
function __exception_handler(exception) {
	// Error message is the actual error which gets displayed/saved to a log file
	var errorMessage = "";
	var gameName = game_display_name; 
	var logDir = working_directory + "logs/log_" + __time_string() + ".txt"; // Where to save your log to

	// Error header
	errorMessage += "An error has caused "+ gameName +" to crash!\n\nPlease consider sending a screenshot of this message to the developers, or (more helpfully) the log file\n\n";
	
	// Log path 
	errorMessage += "Log saved at: "+ logDir + "\n\n";
	
	// Game info
	errorMessage += "Room: " + room_get_name(room) + "\n";
	
	// Get a list of every object in the room
	errorMessage += "Object List:\n";
	with (all) {
		errorMessage += object_get_name(object_index) + ", ";
	}
	errorMessage += "\n\n\n";
	
	// Runner info
	errorMessage += "Runner state:\n"
	errorMessage += "YYC Enabled: " + string(code_is_compiled());
	errorMessage += "\nTime String: " + time_string() + "\n\n";
	
	// Exception
	errorMessage += "Short Message: \n" + exception.message;
	errorMessage += "\n\nLong Message: \n" + exception.longMessage;
	errorMessage += "\nScript/exception location: " + exception.script;
	
	// Stack
	errorMessage += "\n\n\nStack:\n";
	for (var i = 0; i < array_length(exception.stacktrace); i ++) {
		errorMessage += exception.stacktrace[0] + "\n";	
	}
	
	// Commented out, but if you want, an unformatted version of the exception 
	//errorMessage += "\n\nRaw error: \n"
	//errorMessage += string(exception);
	
	// Save the exception to a log
	var logFile = file_text_open_write(logDir);
	file_text_write_string(logFile, errorMessage);
	file_text_close(logFile);
	
	show_message(errorMessage);
}
