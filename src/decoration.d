module src.decoration;

/// command line character decorations
enum DECO: string {
	clear			= "\x1b[0m",
	
	bold			= "\x1b[1m",
	underline		= "\x1b[4m",
	reverse			= "\x1b[7m",
	
	f_black			= "\x1b[30m",
	f_red			= "\x1b[31m",
	f_green			= "\x1b[32m",
	f_yellow		= "\x1b[33m",
	f_blue			= "\x1b[34m",
	f_magenta		= "\x1b[35m",
	f_cyan			= "\x1b[36m",
	f_gray			= "\x1b[37m",
	f_default		= "\x1b[39m",
	
	b_black			= "\x1b[40m",
	b_red			= "\x1b[41m",
	b_green			= "\x1b[42m",
	b_yellow		= "\x1b[43m",
	b_blue			= "\x1b[44m",
	b_magenta		= "\x1b[45m",
	b_cyan			= "\x1b[46m",
	b_gray			= "\x1b[47m",
	b_default		= "\x1b[49m",
}