module decoration;

/// command line character decorations
static struct DECO {
	static immutable string
		nothing			= "",
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
		
		source_code = f_cyan
	;
}

/// decoration function
pure string decorate(string str, string deco1, string deco2=DECO.nothing) {
	import std: among, to;
	const num = deco1[2 .. $-1].to!byte;
	if (deco2 == DECO.nothing) {
		if      (num/10 == 3) deco2 = DECO.f_default;
		else if (num/10 == 4) deco2 = DECO.b_default;
		else                  deco2 = DECO.clear;
	}
	return deco1 ~ str ~ deco2;
}