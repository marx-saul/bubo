/**
 * token.d
 * Define all tokens and struct Location / Token
 */
module token;

/// define all tokens 
enum TokenKind : ubyte {
	error = 0,
	new_line,				// \n
	inc_indent,				// indent depth + 1
	dec_indent,				// indent depth - 1
	end_of_file,			// eof
	exclam,					// !
	neq,					// !=
	dollar,					// $
	mod,					// %
	mod_ass,				// %=
	and,					// &
	andand,					// &&
	and_ass,				// &=
	lparen,					// (
	rparen,					// )
	mul,					// *
	mul_ass,				// *=
	pow,					// **
	pow_ass,				// **=
	add,					// +
	add_ass,				// +=
	inc,					// ++
	comma,					// ,
	sub,					// -
	sub_ass,				// -=
	dec,					// --
	dot,					// .
	dotdot,					// ..
	dotdotdot,				// ...
	div,					// /
	div_ass,				// /=
	colon,					// :
	semicolon,				// ;
	ls,						// <
	leq,					// <=
	lshift,					// <<
	ass,					// =
	eq,						// ==
	gt,						// >
	geq,					// >=
	rshift,					// >>
	logical_shift,			// >>>
	at,						// @
	lbrack,					// [
	rbrack,					// ]
	labmda,					// \
	xor,					// ^
	xor_ass,				// ^=
	xorxor,					// ^^
	any,					// _
	lbrace,					// {
	rbrace,					// }
	or,						// |
	or_ass,					// |=
	oror,					// ||
	tilda,					// ~
	cat_ass,				// ~=
	integer,
	real_number,
	string_literal,
	identifier,
	abstract_,
	as,
	assert_,
	bool_,
	break_,
	char_,
	class_,
	const_,
	continue_,
	deprecated_,
	do_,
	else_,
	export_,
	extern_,
	false_,
	final_,
	for_,
	foreach_,
	foreach_reverse_,
	func,
	goto_,
	if_,
	import_,
	immut,
	int32,
	int64,
	interface_,
	inout_,
	lazy_,
	let,
	match,
	mixin_,
	module_,
	null_,
	out_,
	override_,
	package_,
	private_,
	protected_,
	public_,
	pure_,
	real32,
	real64,
	ref_,
	return_,
	scope_,
	shared_,
	static_,
	string_,
	struct_,
	super_,
	template_,
	this_,
	throwable,
	true_,
	typedef_,
	typeid_,	
	typeof_,
	uint32,
	uint64,
	union_,
	when,
	while_,
}

/// from TokenKind to the string of the token
immutable string[TokenKind.max+1] token_dictionary = [
	TokenKind.exclam:				"!",
	TokenKind.neq:					"!=",
	TokenKind.dollar:				"$",
	TokenKind.mod:					"%",
	TokenKind.mod_ass:				"%=",
	TokenKind.and:					"&",
	TokenKind.andand:				"&&",
	TokenKind.and_ass:				"&=",
	TokenKind.lparen:				"(",
	TokenKind.rparen:				")",
	TokenKind.mul:					"*",
	TokenKind.mul_ass:				"*=",
	TokenKind.pow:					"**",
	TokenKind.pow_ass:				"**=",
	TokenKind.add:					"+",
	TokenKind.add_ass:				"+=",
	TokenKind.inc:					"++",
	TokenKind.comma:				":",
	TokenKind.sub:					"-",
	TokenKind.sub_ass:				"-=",
	TokenKind.dec:					"--",
	TokenKind.dot:					".",
	TokenKind.dotdot:				"..",
	TokenKind.dotdotdot:			"...",
	TokenKind.div:					"/",
	TokenKind.div_ass:				"/=",
	TokenKind.colon:				":",
	TokenKind.semicolon:			";",
	TokenKind.ls:					"<",
	TokenKind.leq:					"<=",
	TokenKind.lshift:				"<<",
	TokenKind.ass:					"=",
	TokenKind.eq:					"==",
	TokenKind.gt:					">",
	TokenKind.geq:					">=",
	TokenKind.rshift:				">>",
	TokenKind.logical_shift:		">>>",
	TokenKind.at:					"@",
	TokenKind.lbrack:				"[",
	TokenKind.rbrack:				"]",
	TokenKind.labmda:				"\\",
	TokenKind.xor:					"^",
	TokenKind.xor_ass:				"^=",
	TokenKind.xorxor:				"^^",
	TokenKind.any:					"_",
	TokenKind.lbrace:				"{",
	TokenKind.rbrace:				"}",
	TokenKind.or:					"|",
	TokenKind.or_ass:				"|=",
	TokenKind.oror:					"||",
	TokenKind.tilda:				"~",
	TokenKind.cat_ass:				"~=",
	TokenKind.abstract_:			"abstract",
	TokenKind.as:					"as",
	TokenKind.assert_:				"assert",
	TokenKind.bool_:				"bool",
	TokenKind.break_:				"break",
	TokenKind.char_:				"char",
	TokenKind.class_:				"class",
	TokenKind.const_:				"const",
	TokenKind.continue_:			"continue",
	TokenKind.deprecated_:			"deprecated",
	TokenKind.do_:					"do",
	TokenKind.else_:				"else",
	TokenKind.export_:				"export",
	TokenKind.extern_:				"extern",
	TokenKind.false_:				"false",
	TokenKind.final_:				"final",
	TokenKind.for_:					"for",
	TokenKind.foreach_:				"foreach",
	TokenKind.foreach_reverse_:		"foreac_reverse",
	TokenKind.func:					"func",
	TokenKind.goto_:				"goto",
	TokenKind.if_:					"if",
	TokenKind.import_:				"import",
	TokenKind.immut:				"immut",
	TokenKind.int32:				"int32",
	TokenKind.int64:				"int64",
	TokenKind.interface_:			"interface",
	TokenKind.inout_:				"inout",
	TokenKind.lazy_:				"lazy",
	TokenKind.let:					"let",
	TokenKind.match:				"match",
	TokenKind.mixin_:				"mixin",
	TokenKind.module_:				"module",
	TokenKind.null_:				"null",
	TokenKind.out_:					"out",
	TokenKind.override_:			"override",
	TokenKind.package_:				"package",
	TokenKind.private_:				"private",
	TokenKind.protected_:			"protected",
	TokenKind.public_:				"public",
	TokenKind.pure_:				"pure",
	TokenKind.real32:				"real32",
	TokenKind.real64:				"real64",
	TokenKind.ref_:					"ref",
	TokenKind.return_:				"return",
	TokenKind.scope_:				"scope",
	TokenKind.shared_:				"shared",
	TokenKind.static_:				"static",
	TokenKind.string_:				"string",
	TokenKind.struct_:				"struct",
	TokenKind.super_:				"super",
	TokenKind.template_:			"template",
	TokenKind.this_:				"this",
	TokenKind.throwable:			"throwable",
	TokenKind.true_:				"true",
	TokenKind.typedef_:				"typedef",
	TokenKind.typeid_:				"typeid",
	TokenKind.typeof_:				"typeof",
	TokenKind.uint32:				"uint32",
	TokenKind.uint64:				"uint64",
	TokenKind.union_:				"union",
	TokenKind.when:					"when",
	TokenKind.while_:				"while",
];

/**
 * The location of a token.
 */
struct Location {
    string path;			/// full path to the file
    size_t line_num;		/// line number
    size_t index_num;		/// index  number among the current line
	
	/// convert to string
	string toString() const {
		import std.conv: to;
		import decoration: DECO;
		return DECO.bold ~ path ~ "(" ~ line_num.to!string ~ ":" ~ index_num.to!string ~ DECO.clear;
	}
}

/**
 * the struct of each token
 */
struct Token {
    Location loc;			/// the location of the token
    TokenKind kind;			/// token kind
    string str;				/// string of the token
}
