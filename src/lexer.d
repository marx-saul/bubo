/**
 * lexer.d
 * All lexing process is done here. It contains indent detection.
 */
module lexer;

import std.algorithm;
import std.array;
import std.ascii;
import std.conv;
import std.meta;
import std.range;
import std.traits;
import std.typecons;
import decoration;
import message;
import token;

private immutable EOF = cast(dchar) -1;		/// EOF character
private immutable BR  = cast(dchar) '\n';	/// new line
private immutable ubyte MAX_LOOKAHEAD = 3;		/// number of characters that the lexer has to look ahead

private enum isCharacterRange(T)
	=  isInputRange!T
	&& is(ReturnType!((T t) => t.front) : const(dchar));

private class CharacterStream(Range)
	if (isCharacterRange!Range)
{
	private Range source;
	
	this (Range r) {
		source = r;
		front_character = r.empty ? EOF : r.front;
		if (front_character == BR) _line_num = 2;
		else _line_num = 1;
		_index_num = 0;
	}
	
	// for lookahead
	private dchar front_character;
	private dchar[MAX_LOOKAHEAD] next_chars;
	private ubyte lookahead_num = 0;
	
	private size_t line_num()  @property @nogc @safe const pure { return _line_num; }
	private size_t _line_num;
	
	private size_t index_num() @property @nogc @safe const pure { return _index_num; }
	private size_t _index_num;
	
	/// current character
	private const(dchar) character() @property {
		return front_character;
	}
	
	/// pop one character
	private void nextChar() {
		if (lookahead_num == 0) {
			if (!source.empty) source.popFront();
			front_character = source.empty ? EOF : source.front;
		}
		else {
			front_character = next_chars[0];
			static foreach (i; 1 .. MAX_LOOKAHEAD) {
				next_chars[i-1] = next_chars[i];
			}
			--lookahead_num;
		}
		// count
		if (front_character == BR) ++_line_num, _index_num = 0;
		else ++_index_num;
	}
	
	/// lookahead
	private const(dchar) lookahead(ubyte k = 1) {
		if (k == 0) return front_character;
		
		ubyte cnt = lookahead_num;
		while (cnt < k) {
			if (!source.empty) source.popFront();
			next_chars[cnt] = source.empty ? EOF : source.front;
			++cnt;
		}
		lookahead_num = max(lookahead_num, k);
		return next_chars[k-1];
	}
}

/**
 * The class of lexer.
 */
class Lexer(Range)
	if (isCharacterRange!Range)
{	
	private alias CS = CharacterStream!Range;
	private CS source;
	private immutable bool allow_2_underbars;
	
	protected immutable string filepath;

	private Token _token;
	protected Token token() @property inout { return _token; }

	/// Get rid of one token.
	protected void nextToken() {
		if (is_lookahead) {
			is_lookahead = false;
			_token = ahead_token;
		}
		else {
			_nextToken();
		}
	}
	
	/// Get k-th next token.
	protected Token lookahead() {
		if (is_lookahead) return ahead_token;
		else {
			const tmp = _token;
			_nextToken();
			ahead_token = _token;
			_token = tmp;
			is_lookahead = true;
			return ahead_token;
		}
	}
	private Token ahead_token;
	private bool is_lookahead;

	/**
	 * Params:
	 *     r = the source range
	 *     path to the file
	 *     a2u = when it is false, it yields error when encountering __id.
	 */
	public this (Range r, string filepath, bool a2u = true) {
		source = new CS(r);
		_nextToken();
		this.filepath = _token.loc.path = filepath;
		allow_2_underbars = a2u;
	}
	
	private void nextChar() { source.nextChar(); }
	
	private long indent_dec = 0;
	private size_t[] indent_nums = [0];
	private dchar indent_char = 'x';
	/// Lexing. Get the next token.
	private void _nextToken() {
		
		// white spaces
		pure @nogc @safe bool isSpace(const dchar c) {
			return c == ' ' || c == '\t';
		}
		
		void ignoreOneLineComment() {
			nextChar();	 // get rid of /
			nextChar();	 // get rid of /
			while (!source.character.among!(BR, EOF))
				nextChar();
		}
		void ignoreMultipleLineComment() {
			nextChar();	 // get rid of /
			nextChar();	 // get rid of *
			while (!(source.character == '*' && source.lookahead() == '/') && source.character != EOF)
				nextChar();
			if (source.character == EOF) { warning(Location(source.line_num, source.index_num), "corresponding */ not found"); }
			nextChar();	 // get rid of *
			nextChar();	 // get rid of /
		}
		void ignoreNestedComment() {
			nextChar(); // get rid of /
			nextChar(); // get rid of +
			size_t comment_depth = 1;
			while (comment_depth > 0 && source.character != EOF) {
				const c_c = source.character, n_c = source.lookahead;
				if	  (c_c == '+' && n_c == '/') {
					--comment_depth;
					nextChar();	 // get rid of +
					nextChar();	 // get rid of /
				}
				else if (c_c == '/' && n_c == '+') {
					++comment_depth;
					nextChar();	 // get rid of /
					nextChar();	 // get rid of +
				}
				else nextChar();
			}
			if (comment_depth != 0) { warning(Location(source.line_num, source.index_num), "corresponding +/ not found"); }
		}
		void ignoreOneLineConcatComment() {
			nextChar();	// get rid of /
			nextChar();	// get rid of -
			while (!source.character.among!(BR, EOF))
				nextChar();
			nextChar();	// get rid of \n
		}
		
		/* ******************************************************************************************************************************
		 ********************************************************************************************************************************
		 ******************************************************************************************************************************** */
		
		if (indent_dec > 0) {
			// set token
			_token.kind = TokenKind.dec_indent;
			_token.loc.line_num  = source.line_num;
			_token.loc.index_num = source.index_num;
			_token.str = "";
			// set new indent
			indent_nums.length -= 1;
			--indent_dec;
			return;
		}
		
		size_t space_num = 0;
		bool br_read;
		bool invalid_indent;
		// intents, spaces and comment
		loop:
		while (source.character != EOF) {
			// space 
			if (isSpace(source.character)) {
				invalid_indent = true;
				nextChar();
				continue;
			}
			// comment
			else if (source.character == '/') {
				switch (source.lookahead()) {
				case '/':
					ignoreOneLineComment();
					invalid_indent = true;
					break;
					
				case '*':
					ignoreMultipleLineComment();
					invalid_indent = true;
					break;
				
				case '+':
					ignoreNestedComment();
					invalid_indent = true;
					break;
					
				case '-':
					ignoreOneLineConcatComment();
					invalid_indent = true;
					break;
					
				default:
					break loop;
				}
				continue;
			}
			// BR
			else if (source.character == BR) {
				nextChar();		// get rid of BR
				
				space_num = 0;
				br_read = true;
				invalid_indent = false;
				
				// set indent_char
				if (indent_nums.length == 1) {
					if (isSpace(source.character))
						indent_char = source.character;
					else continue;
				}
				
				// count the number of spaces at the extreme left hand side of that line
				while (source.character == indent_char) {
					source.nextChar();
					++space_num;
				}
				
				continue;
			}
			// else 
			else
				break;
		}
		
		// indentation error
		if (br_read && invalid_indent) {
			error(Location(source.line_num, source.index_num), "Invalid indent, tabs and spaces (and comments) are mixed.");
		}
		// indentation check
		else if (br_read && !invalid_indent) {
			// new indent
			if (space_num > indent_nums[$-1]) {
				// set token
				_token.kind = TokenKind.inc_indent;
				_token.loc.line_num  = source.line_num;
				_token.loc.index_num = source.index_num;
				_token.str = "";
				// set new indent
				indent_nums ~= space_num;
				return;
			}
			// same indent
			else if (space_num == indent_nums[$-1]) {
				// set token
				_token.kind = TokenKind.new_line;
				_token.loc.line_num  = source.line_num;
				_token.loc.index_num = source.index_num;
				_token.str = "";
				return;
			}
			else {
				auto si = assumeSorted(indent_nums);
				auto si2 = si.lowerBound(space_num + 1);	// list of the elements <= space_num
				// same indentation appeared before
				indent_dec = si.length - si2.length;
				if (si2[$-1] != space_num) {
					error(Location(source.line_num, source.index_num),
						"Invalid indent, the number of spaces of this line is " ~ space_num.to!string ~
						", but previous indent has " ~ si2[$-1].to!string ~ " spaces." ~ 
						"Indent decreases by " ~ indent_dec.to!string ~ " here."
					);
				}
			}
		}

		_token.loc.line_num  = source.line_num;
		_token.loc.index_num = source.index_num;

		immutable(dchar)[] str;
		// identifier of reserved words
		with (TokenKind)
		if (source.character.isAlpha() || source.character == '_') {
			while (source.character.isAlphaNum() || source.character == '_') {
				str ~= source.character;
				nextChar();
			}
			switch (str) {
				case "_":					_token.kind = any;					break;
				case "abstract":			_token.kind = abstract_;			break;
				case "as":					_token.kind = as;					break;
				case "assert":				_token.kind = assert_;				break;
				case "bool":				_token.kind = bool_;				break;
				case "break":				_token.kind = break_;				break;
				case "char":				_token.kind = char_;				break;
				case "class":				_token.kind = class_;				break;
				case "const":				_token.kind = const_;				break;
				case "continue":			_token.kind = continue_;			break;
				case "def":					_token.kind = def;					break;
				case "deprecated":			_token.kind = deprecated_;			break;
				case "do":					_token.kind = do_;					break;
				case "else":				_token.kind = else_;				break;
				case "export":				_token.kind = export_;				break;
				case "extern":				_token.kind = extern_;				break;
				case "false":				_token.kind = false_;				break;
				case "final":				_token.kind = final_;				break;
				case "for":					_token.kind = for_;					break;
				case "foreach":				_token.kind = foreach_;				break;
				case "foreach_reverse":		_token.kind = foreach_reverse_;		break;
				case "goto":				_token.kind = goto_;				break;
				case "if":					_token.kind = if_;					break;
				case "import":				_token.kind = import_;				break;
				case "immut":				_token.kind = immut;				break;
				case "in":					_token.kind = in_;					break;
				case "int32":				_token.kind = int32;				break;
				case "int64":				_token.kind = int64;				break;
				case "interface":			_token.kind = interface_;			break;
				case "inout":				_token.kind = inout_;				break;
				case "is":					_token.kind = is_;					break;
				case "lazy":				_token.kind = lazy_;				break;
				case "let":					_token.kind = let;					break;
				case "match":				_token.kind = match;				break;
				case "mixin":				_token.kind = mixin_;				break;
				case "module":				_token.kind = module_;				break;
				case "new":					_token.kind = new_;					break;
				case "null":				_token.kind = null_;				break;
				case "out":					_token.kind = out_;					break;
				case "override":			_token.kind = override_;			break;
				case "package":				_token.kind = package_;				break;
				case "private":				_token.kind = private_;				break;
				case "protected":			_token.kind = protected_;			break;
				case "public":				_token.kind = public_;				break;
				case "pure":				_token.kind = pure_;				break;
				case "real32":				_token.kind = real32;				break;
				case "real64":				_token.kind = real64;				break;
				case "ref":					_token.kind = ref_;					break;
				case "return":				_token.kind = return_;				break;
				case "scope":				_token.kind = scope_;				break;
				case "shared":				_token.kind = shared_;				break;
				case "static":				_token.kind = static_;				break;
				case "string":				_token.kind = string_;				break;
				case "struct":				_token.kind = struct_;				break;
				case "super":				_token.kind = super_;				break;
				case "template":			_token.kind = template_;			break;
				case "this":				_token.kind = this_;				break;
				case "throwable":			_token.kind = throwable;			break;
				case "true":				_token.kind = true_;				break;
				case "typedef":				_token.kind = typedef_;				break;
				case "typeid":				_token.kind = typeid_;				break;
				case "typeof":				_token.kind = typeof_;				break;
				case "uint32":				_token.kind = uint32;				break;
				case "uint64":				_token.kind = uint64;				break;
				case "union":				_token.kind = union_;				break;
				case "void":				_token.kind = void_;				break;
				case "when":				_token.kind = when;					break;
				case "while":				_token.kind = while_;				break;	
				default:					_token.kind = identifier;			break;
			}
			if (!allow_2_underbars && str.length >= 2 && str[0] == '_' && str[1] == '_') {
				message.warning(_token.loc,
				"An identifier starting with two underbars ", str.to!string.decorate(DECO.b_cyan), " is not allowed.");
				str = "_0_" ~ str[2..$];
			}
		}
		// hexical
		else if (source.character == '0' && source.lookahead.among!('x', 'X')) {
			// hexical
			str ~= ['0', source.lookahead];
			nextChar();
			nextChar();
			while (source.character.among!(aliasSeqOf!"0123456789abcdefABCDEF_")) {
				str ~= source.character;
				nextChar();
			}
			// real number
			if (
				source.character == '.'
				// 0x1.; --> 0x1. ;
				// 0x1..2 --> 0x1 .. 2
				// 0x3.repeat --> 0x3 . repeat
				// 0x3._abc ---> 0x3 . _abc
				&& source.lookahead().among!(aliasSeqOf!"._") == 0
				&& !( source.lookahead().isAlpha() && !source.character.among!(aliasSeqOf!"abcdefABCEDF") )
			) {
				nextChar();
				str ~= '.';
				_token.kind = real_number;
				while (source.character.among!(aliasSeqOf!"0123456789abcdefABCDEF_")) {
					str ~= source.character;
					nextChar();
				}
			}
			else {
				_token.kind = integer;
			}
		}
		// binary
		else if (source.character == '0' && source.lookahead.among!('b', 'B')) {
			str ~= ['0', source.lookahead];
			nextChar();
			nextChar();
			while (source.character.among!(aliasSeqOf!"01_")) {
				str ~= source.character;
				nextChar();
			}
			// real number
			if (
				source.character == '.'
				&& source.lookahead().among!(aliasSeqOf!"._") == 0
				&& !( source.character.isAlpha() )
			) {
				nextChar();
				str ~= '.';
				_token.kind = real_number;
				while (source.character.among!(aliasSeqOf!"01_")) {
					str ~= source.character;
					nextChar();
				}
			}
			else {
				_token.kind = integer;
			}
		}
		// 10
		else if (source.character.isDigit()) {
			while (source.character.among!(aliasSeqOf!"0123456789_")) {
				str ~= source.character;
				nextChar();
			}
			// real number
			if (
					source.character == '.'
				&& source.lookahead().among!(aliasSeqOf!"._") == 0
				&& !source.lookahead().isAlpha()
			) {
				nextChar();
				str ~= '.';
				_token.kind = real_number;
				while (source.character.among!(aliasSeqOf!"0123456789_")) {
					str ~= source.character;
					nextChar();
				}
			}
			else {
				_token.kind = integer;
			}
		}
		// strings
		else if (source.character == '"') {
			_token.kind = string_literal;
			nextChar(); // get rid of "
			while (!source.character.among!('"', EOF)) {
				if (source.character == '\\') {
					nextChar();	 // get rid of \
					switch (source.character) {
						case '\\':str ~= '\\'; break;
						case '"': str ~= '"';  break;
						case '0': str ~= '\0'; break;
						case 'a': str ~= '\a'; break;
						case 'b': str ~= '\b'; break;
						case 'f': str ~= '\f'; break;
						case 'n': str ~= '\n'; break;
						case 'r': str ~= '\r'; break;
						case 't': str ~= '\t'; break;
						case 'v': str ~= '\v'; break;
						// invalid escape sequence
						default:
							message.error(Location(source.line_num, source.index_num), "Invalid escape sequence \\",
								source.character == EOF ? "EOF" : source.character.to!string);
							break;
					}
					nextChar();	 // get rid of the escape sequence
				}
				str ~= source.character;
				nextChar();
			}
			nextChar();
		}
		// symbols
		else if (source.character == '!') {
			nextChar();	 // get rid of !
			const c = source.character;
			if (
				c == 'i'
			 && source.lookahead(1) == 's'
			 && !(source.lookahead(2).isAlphaNum() || source.lookahead(2) == '_')
			) {
				nextChar();	 // get rid of i
				nextChar();	 // get rid of s
				_token.kind = nis;
				str = "!is";
			}
			else if (
				c == 'i'
			 && source.lookahead(1) == 'n'
			 && !(source.lookahead(2).isAlphaNum() || source.lookahead(2) == '_')
			) {
				nextChar();	 // get rid of i
				nextChar();	 // get rid of n
				_token.kind = nin;
				str = "!in";
			}
			else if	  (c == '=') {
				nextChar();	 // get rid of =
				_token.kind = neq;
				str = "!=";
			}
			else {
				_token.kind = exclam;
				str = "!";
			}
		}
		else if (source.character == '$') {
			nextChar();	 // get rid of $
			_token.kind = dollar;
			str = "$";
		}
		else if (source.character == '%') {
			nextChar();	 // get rid of %
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = mod_ass;
				str = "%=";
			}
			else {
				_token.kind = mod;
				str = "%";
			}
		}
		else if (source.character == '&') {
			nextChar();	 // get rid of &
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = and_ass;
				str = "&=";
			}
			else if (source.character == '&') {
				nextChar();	 // get rid of &
				_token.kind = andand;
				str = "&&";
			}
			else {
				_token.kind = and;
				str = "&";
			}
		}
		else if (source.character == '|') {
			nextChar();	 // get rid of %
			if (source.character == '>') {
				nextChar();	 // get rid of >
				_token.kind = pipeline;
				str = "|>";
			}
			else if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = or_ass;
				str = "|=";
			}
			else if (source.character == '|') {
				nextChar();	 // get rid of |
				_token.kind = oror;
				str = "||";
			}
			else {
				_token.kind = or;
				str = "|";
			}
		}
		else if (source.character == '^') {
			nextChar();	 // get rid of ^
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = xor_ass;
				str = "^=";
			}
			else if (source.character == '^') {
				nextChar();	 // get rid of ^
				_token.kind = xorxor;
				str = "^^";
			}
			else {
				_token.kind = xor;
				str = "^";
			}
		}
		else if (source.character == '~') {
			nextChar();	 // get rid of ~
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = cat_ass;
				str = "~=";
			}
			else {
				_token.kind = tilde;
				str = "~";
			}
		}
		else if (source.character == '(') {
			nextChar();	 // get rid of (
			_token.kind = lparen;
			str = "(";
		}
		else if (source.character == ')') {
			nextChar();	 // get rid of )
			_token.kind = rparen;
			str = ")";
		}
		else if (source.character == '{') {
			nextChar();	 // get rid of {
			_token.kind = lbrace;
			str = "{";
		}
		else if (source.character == '}') {
			nextChar();	 // get rid of }
			_token.kind = rbrace;
			str = "}";
		}
		else if (source.character == '[') {
			nextChar();	 // get rid of [
			_token.kind = lbracket;
			str = "[";
		}
		else if (source.character == ']') {
			nextChar();	 // get rid of ]
			_token.kind = rbracket;
			str = "]";
		}
		else if (source.character == '*') {
			nextChar();	 // get rid of *
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = mul_ass;
				str = "*=";
			}
			else if (source.character == '*') {
				nextChar();	 // get rid of *
				if (source.character == '=') {
					nextChar();
					_token.kind = pow_ass;
					str = "**=";
				}
				else {
					_token.kind = pow;
					str = "**";
				}
			}
			else {
				_token.kind = mul;
				str = "*";
			}
		}
		else if (source.character == '+') {
			nextChar();	 // get rid of +
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = add_ass;
				str = "+=";
			}
			else if (source.character == '+') {
				nextChar();	 // get rid of +
				_token.kind = inc;
				str = "++";
			}
			else {
				_token.kind = add;
				str = "+";
			}
		}
		else if (source.character == '/') {
			nextChar();	 // get rid of /
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = div_ass;
				str = "/=";
			}
			else {
				_token.kind = div;
				str = "/";
			}
		}
		else if (source.character == '-') {
			nextChar();	 // get rid of -
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = sub_ass;
				str = "-=";
			}
			else if (source.character == '-') {
				nextChar();	 // get rid of -
				_token.kind = inc;
				str = "--";
			}
			else if (source.character == '>') {
				nextChar();	 // get rid of >
				_token.kind = arrow;
				str = "->";
			}
			else {
				_token.kind = sub;
				str = "-";
			}
		}
		else if (source.character == ',') {
			nextChar();	 // get rid of ,
			_token.kind = comma;
			str = ",";
		}
		else if (source.character == '.') {
			nextChar();	 // get rid of .
			if (source.character == '.') {
				nextChar();	 // get rid of .
				_token.kind = dotdot;
				str = "..";
			}
			else {
				_token.kind = dot;
				str = ".";
			}
		}
		else if (source.character == ':') {
			nextChar();	 // get rid of :
			_token.kind = colon;
			str = ":";
		}
		else if (source.character == ';') {
			nextChar();	 // get rid of ;
			_token.kind = semicolon;
			str = ";";
		}
		else if (source.character == '<') {
			nextChar();	 // get rid <
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = leq;
				str = "<=";
			}
			else if (source.character == '<') {
				nextChar();	 // get rid of <
				if (source.character == '=') {
					nextChar();	 // get rid of =
					_token.kind = lshift_ass;
					str = "<<=";
				}
				else {
					_token.kind = lshift;
					str = "<<";
				}
			}
			else {
				_token.kind = ls;
				str = "<";
			}
		}
		else if (source.character == '>') {
			nextChar();	 // get rid >
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = geq;
				str = ">=";
			}
			else if (source.character == '>') {
				nextChar();	 // get rid of >
				if (source.character == '>') {
					nextChar();  // get rid of >
					if (source.character == '=') {
						nextChar();	 // get rid of =
						_token.kind = logical_shift_ass;
						str = ">>>=";
					}
					else {
						_token.kind = logical_shift;
						str = ">>>";
					}
				}
				else if (source.character == '=') {
					nextChar();	 // get rid of =
					_token.kind = rshift_ass;
					str = ">>=";
				}
				else {
					_token.kind = rshift;
					str = ">>";
				}
			}
			else {
				_token.kind = gt;
				str = ">";
			}
		}
		else if (source.character == '=') {
			nextChar();	 // get rid of =
			if (source.character == '=') {
				nextChar();	 // get rid of =
				_token.kind = eq;
				str = "==";
			}
			else if (source.character == '>') {
				nextChar();	 // get rid of >
				_token.kind = big_arrow;
				str = "=>";
			}
			else {
				_token.kind = ass;
				str = "=";
			}
		}
		else if (source.character == '@') {
			nextChar();	 // get rid of @
			_token.kind = at;
			str = "@";
		}
		else if (source.character == '\\') {
			nextChar();	 // get rid of \
			_token.kind = lambda;
			str = "\\";
		}
		else if (source.character == BR) {
			nextChar();  // get rid of \n
			_token.kind = new_line;
			str = (DECO.reverse ~ "BR" ~ DECO.clear).to!dstring;
		}
		else if (source.character == EOF) {
			_token.kind = end_of_file;
			str = "EOF";
		}
		else {
			message.error(Location(source.line_num, source.index_num),
				"Invalid character '", decorate(source.character.to!string,  DECO.bold), "'."
			);
			nextChar();
		}
		
		_token.str = str.to!string;
	}
}

unittest {
	import std.stdio;
	writeln("lexer".decorate(DECO.f_green));
	
	auto lx = new Lexer!(string)(`
is !is in !in !is_error !in_set
> >= >> >>> >>= >>>= < <= << <<=
/*/ comment /*/
/+/ /++/ +/
id /*01234 009_124*/ 0xFFf 0x0.aF_f
  AAAAAAAAAAAAAAAAAAA
  =+=-=*=/=%=++=$=^=|=~~^^^^==>&&&|||&&
  !isAlpha
//  	!isAlpha									// ERROR HERE
~in ~is ~in3_set
~is_odd![3..$ 4 ..
	XXXXX YYYYY /- cat the next line
	ZZZZZ /- 
	/* */ WWWWW
`, "main.bb");
	while (lx._token.kind != TokenKind.end_of_file) {
		writeln(lx._token.kind, "\t", lx._token.str, "\t//\t", lx._token.loc.line_num, ":", lx._token.loc.index_num);
		//writeln(lx.lookahead.str);
		lx.nextToken();
	}
}