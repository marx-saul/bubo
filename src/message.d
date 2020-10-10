/**
 * message.d
 * Yields error messages.
 */
module message;

import std.stdio;
import decoration;
import token: Location;

/**
 * Display error message.
 * Params:
 * 		loc  = the location of the error
 * 		msgs = error messages
 */
void error(Location loc, string[] msgs...) {
	if (loc != Location.init) write(loc.toString(), ": ");
	write(DECO.f_red ~ "Error: " ~ DECO.f_default);
	write(DECO.bold ~ "");
	show_message(msgs);
	write(DECO.clear ~ "");
}
/**
 * Display Warning message.
 * Params:
 * 		loc  = the location of the warning
 * 		msgs = warning messages
 */
void warning(Location loc, string[] msgs...) {
	if (loc != Location.init) write(loc.toString(), ": ");
	write(DECO.f_red ~ "Warning: " ~ DECO.f_default);
	write(DECO.bold ~ "");
	show_message(msgs);
	write(DECO.clear ~ "");
}

private void show_message(string[] msgs...) {
	foreach (msg; msgs) {
		write(msg);
	}
	writeln();
}

/**
 * Display currently called function for debugging.
 */
void semlog(T...)(T args) {
	if (leave_log) writeln(args);
}
private auto leave_log = true; // currently