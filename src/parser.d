module parser;

import std.algorithm;
import ast;
import decoration;
import identifier;
import lexer;
import token;

/// parser class
final class Parser(Range) : Lexer!Range {
	/// Create parser.
	this (Range range, string filepath="tmp.oak", bool a2u=true) {
		super(range, filepath, a2u);
	}
	
	/// Check if the current token is the designated one, and throw it away.
	/// If not, throw away all the token until it reaches the expected token or EOF.
	private void check(TokenKind kind) {
		auto loc = token.loc;
		if (token.kind == kind) {
			nextToken();
			return;
		}
		// error
		auto err_kind = token.kind;
		do {
			nextToken();
		} while(token.kind != kind && token.kind != TokenKind.end_of_file);
		import std.conv: to;
		error(loc, token_dictionary[kind], " was expected, not ", token_dictionary[err_kind]);
	}
	
	private bool _is_error;
	/// Whether there was a syntax error
	public  bool is_error() @property const {
		return _is_error;
	}
	/// The number of errors that this parser will generate
	public uint error_left = 10;
	private void error(Location loc, string[] msgs...) {
		import message: error;
		if (error_left > 0) {
			--error_left;
			error(loc, msgs);
		}
		_is_error = true;
	}
	
	private bool _is_warning;
	/// Whether there was a syntax warning
	public  bool is_warning() @property const {
		return _is_warning;
	}
	/// The number of errors that this parser will generate
	public uint warning_left = 10;
	private void warning(Location loc, string[] msgs...) {
		import message: warning;
		if (warning_left > 0) {
			--warning_left;
			warning(loc, msgs);
		}
		_is_warning = true;
	}
	
	
	/***********************************************************************************************************
	 * Expression
	 */
	alias parseExpression = parseAssignExpression;
	
	/+Expression parseWhenElseExpression() {
		if (token.kind == TokenKind.when) {
			auto loc = token.loc;
			nextToken();	// get rid of when
			auto cond = parseExpression();
			check(TokenKind.colon);
			auto when_exp = parseExpression();
			check(TokenKind.else_);
			auto else_exp = parseWhenElseExpression();
			return new WhenElseExpression(loc, cond, when_exp, else_exp);
		}
		else return parseAssignExpression();
	}+/
	
	Expression parseAssignExpression() {
		auto e1 = parsePipelineExpression();
		with (TokenKind) {
			auto loc = token.loc;
			switch (token.kind) {
			case ass:
				nextToken();	// get rid of =
				auto e2 = parseAssignExpression();
				e1 = new AssignExpression(loc, e1, e2);
				break;
				
			case or_ass:
				nextToken();	// get rid of |=
				auto e2 = parseAssignExpression();
				e1 = new OrAssignExpression(loc, e1, e2);
				break;
				
			case xor_ass:
				nextToken();	// get rid of ^=
				auto e2 = parseAssignExpression();
				e1 = new XorAssignExpression(loc, e1, e2);
				break;
				
			case and_ass:
				nextToken();	// get rid of &=
				auto e2 = parseAssignExpression();
				e1 = new AndAssignExpression(loc, e1, e2);
				break;
				
			case lshift_ass:
				nextToken();	// get rid of <<=
				auto e2 = parseAssignExpression();
				e1 = new LShiftAssignExpression(loc, e1, e2);
				break;
				
			case rshift_ass:
				nextToken();	// get rid of >>=
				auto e2 = parseAssignExpression();
				e1 = new RShiftAssignExpression(loc, e1, e2);
				break;
				
			case logical_shift_ass:
				nextToken();	// get rid of >>>=
				auto e2 = parseAssignExpression();
				e1 = new LogicalShiftAssignExpression(loc, e1, e2);
				break;
				
			case add_ass:
				nextToken();	// get rid of +=
				auto e2 = parseAssignExpression();
				e1 = new AddAssignExpression(loc, e1, e2);
				break;
				
			case sub_ass:
				nextToken();	// get rid of -=
				auto e2 = parseAssignExpression();
				e1 = new SubAssignExpression(loc, e1, e2);
				break;
				
			case cat_ass:
				nextToken();	// get rid of ~=
				auto e2 = parseAssignExpression();
				e1 = new CatAssignExpression(loc, e1, e2);
				break;
				
			case mul_ass:
				nextToken();	// get rid of *=
				auto e2 = parseAssignExpression();
				e1 = new MulAssignExpression(loc, e1, e2);
				break;
				
			case div_ass:
				nextToken();	// get rid of /=
				auto e2 = parseAssignExpression();
				e1 = new DivAssignExpression(loc, e1, e2);
				break;
				
			case mod_ass:
				nextToken();	// get rid of %=
				auto e2 = parseAssignExpression();
				e1 = new ModAssignExpression(loc, e1, e2);
				break;
				
			case pow_ass:
				nextToken();	// get rid of **=
				auto e2 = parseAssignExpression();
				e1 = new PowAssignExpression(loc, e1, e2);
				break;
				
			default: break;
			}
		}
		
		return e1;
	}
	
	Expression parsePipelineExpression() {
		auto e1 = parseOrOrExpression();
		
		while (token.kind == TokenKind.pipeline) {
			auto loc = token.loc;
			nextToken();	// get rid of |>
			auto e2 = parseOrOrExpression();
			e1 = new PipelineExpression(loc, e1, e2);
		}
		
		return e1;
	}
	
	Expression parseOrOrExpression() {
		auto e1 = parseXorXorExpression();
		
		while (token.kind == TokenKind.oror) {
			auto loc = token.loc;
			nextToken();	// get rid of ||
			auto e2 = parseXorXorExpression();
			e1 = new OrOrExpression(loc, e1, e2);
		}
		
		return e1;
	}
	
	Expression parseXorXorExpression() {
		auto e1 = parseAndAndExpression();
		
		while (token.kind == TokenKind.xorxor) {
			auto loc = token.loc;
			nextToken();	// get rid of ^^
			auto e2 = parseAndAndExpression();
			e1 = new XorXorExpression(loc, e1, e2);
		}
		
		return e1;
	}
	
	Expression parseAndAndExpression() {
		auto e1 = parseOrExpression();
		
		while (token.kind == TokenKind.andand) {
			auto loc = token.loc;
			nextToken();	// get rid of &&
			auto e2 = parseOrExpression();
			e1 = new AndAndExpression(loc, e1, e2);
		}
		
		return e1;
	}
	
	Expression parseOrExpression() {
		auto e1 = parseXorExpression();
		
		while (token.kind == TokenKind.or) {
			auto loc = token.loc;
			nextToken();	// get rid of |
			auto e2 = parseXorExpression();
			e1 = new OrExpression(loc, e1, e2);
		}
		
		return e1;
	}
	
	Expression parseXorExpression() {
		auto e1 = parseAndExpression();
		
		while (token.kind == TokenKind.xor) {
			auto loc = token.loc;
			nextToken();	// get rid of ^
			auto e2 = parseAndExpression();
			e1 = new XorExpression(loc, e1, e2);
		}
		
		return e1;
	}
	
	Expression parseAndExpression() {
		auto e1 = parseCmpExpression();
		
		while (token.kind == TokenKind.and) {
			auto loc = token.loc;
			nextToken();	// get rid of &
			auto e2 = parseCmpExpression();
			e1 = new AndExpression(loc, e1, e2);
		}
		
		return e1;
	}
	
	Expression parseCmpExpression() {
		auto e1 = parseShiftExpression();
		with (TokenKind) {
			auto loc = token.loc;
			switch (token.kind) {
			case is_:
				nextToken();	// get rid of is
				auto e2 = parseShiftExpression();
				e1 = new IdentityExpression(loc, e1, false, e2);
				break;
			
			case nis:
				nextToken();	// get rid of !is
				auto e2 = parseShiftExpression();
				e1 = new IdentityExpression(loc, e1, true, e2);
				break;
				
			case in_:
				nextToken();	// get rid of in
				auto e2 = parseShiftExpression();
				e1 = new InExpression(loc, e1, false, e2);
				break;
					
			case nin:
				nextToken();	// get rid of in
				auto e2 = parseShiftExpression();
				e1 = new InExpression(loc, e1, true, e2);
				break;
				
			case ls:
				nextToken();	// get rid of <
				auto e2 = parseShiftExpression();
				e1 = new LsExpression(loc, e1, e2);
				break;
				
			case leq:
				nextToken();	// get rid of <=
				auto e2 = parseShiftExpression();
				e1 = new LeqExpression(loc, e1, e2);
				break;
				
			case gt:
				nextToken();	// get rid of >
				auto e2 = parseShiftExpression();
				e1 = new GtExpression(loc, e1, e2);
				break;
				
			case geq:
				nextToken();	// get rid of >=
				auto e2 = parseShiftExpression();
				e1 = new GeqExpression(loc, e1, e2);
				break;
				
			case eq:
				nextToken();	// get rid of ==
				auto e2 = parseShiftExpression();
				e1 = new EqExpression(loc, e1, false, e2);
				break;
				
			case neq:
				nextToken();	// get rid of !=
				auto e2 = parseShiftExpression();
				e1 = new EqExpression(loc, e1, true, e2);
				break;
				
			default: break;
			}
		}
		
		return e1;
	}
	
	Expression parseShiftExpression() {
		auto e1 = parseAddExpression();
		loop:
		while (true) {
			auto loc = token.loc;
			with (TokenKind)
			switch (token.kind) {
			case lshift:
				nextToken();	// get rid of <<
				auto e2 = parseAddExpression();
				e1 = new LShiftExpression(loc, e1, e2);
				break;
				
			case rshift:
				nextToken();	// get rid of >>
				auto e2 = parseAddExpression();
				e1 = new LShiftExpression(loc, e1, e2);
				break;
			
			case logical_shift:
				nextToken();	// get rid of >>>
				auto e2 = parseAddExpression();
				e1 = new LogicalShiftExpression(loc, e1, e2);
				break;
				
			default: break loop;
			}
		}
		
		return e1;
	}
	
	Expression parseAddExpression() {
		auto e1 = parseMulExpression();
		loop:
		while (true) {
			auto loc = token.loc;
			with (TokenKind)
			switch (token.kind) {
			case add:
				nextToken();	// get rid of +
				auto e2 = parseMulExpression();
				e1 = new AddExpression(loc, e1, e2);
				break;
				
			case sub:
				nextToken();	// get rid of -
				auto e2 = parseMulExpression();
				e1 = new SubExpression(loc, e1, e2);
				break;
			
			case tilde:
				nextToken();	// get rid of ~
				auto e2 = parseMulExpression();
				e1 = new CatExpression(loc, e1, e2);
				break;
				
			default: break loop;
			}
		}
		
		return e1;
	}
	
	Expression parseMulExpression() {
		auto e1 = parseUnaryExpression();
		loop:
		while (true) {
			auto loc = token.loc;
			with (TokenKind)
			switch (token.kind) {
			case mul:
				nextToken();	// get rid of *
				auto e2 = parseUnaryExpression();
				e1 = new MulExpression(loc, e1, e2);
				break;
				
			case div:
				nextToken();	// get rid of /
				auto e2 = parseUnaryExpression();
				e1 = new DivExpression(loc, e1, e2);
				break;
			
			case mod:
				nextToken();	// get rid of %
				auto e2 = parseUnaryExpression();
				e1 = new ModExpression(loc, e1, e2);
				break;
				
			default: break loop;
			}
		}
		
		return e1;
	}
	
	Expression parseUnaryExpression() {
		auto loc = token.loc;
		with (TokenKind)
		switch (token.kind) {
		case inc:
			nextToken();	// get rid of ++
			auto e1 = parseUnaryExpression();
			return new PreIncExpression(loc, e1);
			
		case dec:
			nextToken();	// get rid of --
			auto e1 = parseUnaryExpression();
			return new PreDecExpression(loc, e1);
			
		case and:
			nextToken();	// get rid of &
			auto e1 = parseUnaryExpression();
			return new RefExpression(loc, e1);
			
		case mul:
			nextToken();	// get rid of *
			auto e1 = parseUnaryExpression();
			return new DerefExpression(loc, e1);
			
		case add:
			nextToken();	// get rid of +
			auto e1 = parseUnaryExpression();
			return new PlusExpression(loc, e1);
			
		case sub:
			nextToken();	// get rid of -
			auto e1 = parseUnaryExpression();
			return new MinusExpression(loc, e1);
			
		case exclam:
			nextToken();	// get rid of !
			auto e1 = parseUnaryExpression();
			return new NotExpression(loc, e1);
		
		case tilde:
			nextToken();	// get rid of ~
			auto e1 = parseUnaryExpression();
			return new ComplementExpression(loc, e1);
			
		default:
			return parsePowExpression();
		}
	}
	
	Expression parsePowExpression() {
		auto e1 = parsePostfixExpression();
		
		if (token.kind == TokenKind.pow) {
			auto loc = token.loc;
			nextToken();	// get rid of **
			auto e2 = parseUnaryExpression();
			e1 = new PowExpression(loc, e1, e2);
		}
		
		return e1;
	}
	
	Expression parsePostfixExpression() {
		auto e1 = parsePrimaryExpression();
		loop:
		while (true) {
			auto loc = token.loc;
			with (TokenKind)
			switch (token.kind) {
			case inc:
				nextToken();	// get rid of ++
				e1 = new PostIncExpression(loc, e1);
				break;
				
			case dec:
				nextToken();	// get rid of --
				e1 = new PostDecExpression(loc, e1);
				break;
			
			case dot:
				while (token.kind == dot) {
					auto loc2 = token.loc;
					nextToken();	// get rid of .
					switch (token.kind) {
					case identifier:
						// template instance
						if (lookahead().kind == exclam) {
							assert(0, "has not been implemented yet");
							//to do
						}
						else {
							auto e2 = new IdentifierExpression(Identifier(token.loc, token.str), false);
							nextToken();	// get rid of Identifier
							e1 = new DotExpression(loc2, e1, e2);
						}
						break;
					
					case new_:
						auto e2 = parseNewExpression();
						e1 = new DotExpression(loc, e1, e2);
						break;
					
					// error
					default:
						this.error(token.loc,
							"An identifier or ", "new".decorate(DECO.source_code),
							" was expected after " ~  ".".decorate(DECO.source_code),
							", not " ~ token.str.decorate(DECO.source_code) ~ "."
							);
						break;
					}
				}
				break;
			
			case lparen:
				nextToken();	// get rid of (
				if (token.kind == rparen) {
					nextToken();	// get rid of )
					e1 = new CallExpression(loc, e1, []);
				}
				else {
					auto params = parseExpressions();
					if (token.kind == comma) nextToken();	// get rid of ,
					check(rparen);
					e1 = new CallExpression(loc, e1, params);
				}
				break;
			
			case lbracket:
				nextToken();	// get rid of [
				// a[]
				if (token.kind == rbracket) {
					nextToken();	// get rid of ]
					e1 = new IndexExpression(loc, e1, []);
				}
				else {
					auto params1 = [parseExpression()];
					// a[b .. c, d .. e, ...]
					if (token.kind == dotdot) {
						nextToken();	// get rid of ..
						auto params2 = [parseExpression()];
						while (token.kind == comma) {
							nextToken();	// get rid of ,
							if (token.kind == rbracket) break;
							params1 ~= parseExpression();
							check(dotdot);
							params2 ~= parseExpression();
						}
						check(rbracket);
						e1 = new SliceExpression(loc, e1, params1, params2);
					}
					// a[b, c, d]
					else {
						while (token.kind == comma) {
							nextToken();	// get rid of ,
							if (token.kind == rbracket) break;
							params1 ~= parseExpression();
						}
						check(rbracket);
						e1 = new IndexExpression(loc, e1, params1);
					}
				}
				break;
			
			default: break loop;
			}
		}
		
		return e1;
	}
	
	Expression parsePrimaryExpression() {
		Expression result;
		
		with (TokenKind)
		switch (token.kind) {
		case false_:
			result = new FalseExpression(token.loc);
			nextToken();	// get rid of false
			break;
			
		case true_:
			result = new TrueExpression(token.loc);
			nextToken();	// get rid of true
			break;
			
		case null_:
			result = new NullExpression(token.loc);
			nextToken();	// get rid of null
			break;
			
		case this_:
			result = new ThisExpression(token.loc);
			nextToken();	// get rid of this
			break;
			
		case super_:
			result = new SuperExpression(token.loc);
			nextToken();	// get rid of super
			break;
			
		case dollar:
			result = new DollarExpression(token.loc);
			nextToken();	// get rid of $
			break;
			
		case any:
			result = new DollarExpression(token.loc);
			nextToken();	// get rid of _
			break;
		
		case integer:
			result = new IntegerExpression(token.loc, token.str);
			nextToken();	// get rid of integer
			break;
		
		case real_number:
			result = new RealNumberExpression(token.loc, token.str);
			nextToken();	// get rid of real number
			break;
		
		case string_literal:
			result = new StringExpression(token.loc, token.str);
			nextToken();	// get rid of string literal
			break;
		
		case identifier:
			if (lookahead().kind == exclam) {
				assert(0, "has not implemented yet");
			}
			else {
				result = new IdentifierExpression(Identifier(token.loc, token.str), false);
				nextToken();	// get rid of identifier
			}
			break;
		
		case dot:
			nextToken();	// get rid of .
			if (token.kind == identifier) {
				if (lookahead().kind == exclam) {
					assert(0, "has not implemented yet");
				}
				else {
					result = new IdentifierExpression(Identifier(token.loc, token.str), true);
					nextToken();	// get rid of identifier
				}
			}
			else {
				this.error(token.loc,
					"An identifier was expected after " ~  ".".decorate(DECO.source_code),
					", not " ~ token.str.decorate(DECO.source_code) ~ "."
				);
			}
			break;
			
		case lparen:
			return parseTupleExpression();
		
		case lbracket:
			return parseArrayExpression();
		
		//case lbrace:
		
		case new_:
			return parseNewExpression();
		/*
		case int32:
		case uint32:
		case int64:
		case uint64:
		case real32:
		case real64:
		case void:
		*/
		
		//case typeid_:
		//case typeof_:
		//case lambda:
			//return parseLambdaExpression();
		//case assert_:
			//return parseAssertExpression();
		//case mixin_:
			//return parseMixinExpression();
		//case import_:
			//return parseImportExpression();
			
		default:
			this.error(token.loc,
				"An expression was expected, not " ~ token.str.decorate(DECO.source_code) ~ "."
			);
			break;
		}
		
		return result;
	}
	
	Expression parseTupleExpression() {
		auto loc = token.loc;
		
		check(TokenKind.lparen);
		auto elems = parseExpressions();
		if (token.kind == TokenKind.comma) nextToken();	// get rid of ,
		check(TokenKind.rparen);
		
		if (elems.length > 1) {
			return new TupleExpression(token.loc, elems);
		}
		else {
			if (elems[0]) elems[0].paren = true;
			return elems[0];
		}
	}
	
	Expression parseArrayExpression() {
		auto loc = token.loc;
		check(TokenKind.rbracket);
		with (TokenKind)
		if (token.kind == rbracket) {
			nextToken();	// get rid of ]
			return new ArrayExpression(loc, []);
		}
		else {
			auto params1 = [parseExpression()];
			// a[b : c, d : e, ...]
			if (token.kind == colon) {
				nextToken();	// get rid of :
				auto params2 = [parseExpression()];
				while (token.kind == comma) {
					nextToken();	// get rid of ,
					if (token.kind == rbracket) break;
					params1 ~= parseExpression();
					check(colon);
					params2 ~= parseExpression();
				}
				check(rbracket);
				return new AssocArrayExpression(loc, params1, params2);
			}
			// a[b, c, d]
			else {
				while (token.kind == comma) {
					nextToken();	// get rid of ,
					if (token.kind == rbracket) break;
					params1 ~= parseExpression();
				}
				check(rbracket);
				return new ArrayExpression(loc, params1);
			}
		}
	}
	
	Expression parseNewExpression() {
		/*
		auto loc = token.loc;
		
		check(TokenKind.new_);
		auto type = parseType();
		if (token.kind == TokenKind.lparen) {
			nextToken();	// get rid of (
			if (token.kind == TokenKind.rparen) {
				nextToken();	// get rid of )
				return new NewExpression(loc, type, elems, false);
			}	
			else {
				auto elems = parseExpressions();
				if (token.kind == TokenKind.comma) nextToken();
				check(TokenKind.rparen);
				return new NewExpression(loc, type, elems, false);
			}
		}
		else {
			return new NewExpression(loc, type, [], true);
		}
		*/
		assert(0, "has not implemented yet.");
	}
	
	Expression[] parseExpressions() {
		auto result = [parseExpression()];
		while (token.kind == TokenKind.comma) {
			nextToken();	// get rid of ,
			result ~= parseExpression();
		}
		return result;
	}
}

unittest {
	import std.stdio;
	import ast.expression_tostring;
	writeln("parser".decorate(DECO.f_green));
	{
		scope parser = new Parser!string("/-
a = ((a == b) & a) * (--b.c.d++(e, f)(g, g)[h][][i..j, k..l] ** -m ** +*~!&n * o / p * q % r + s - t ~ u << v >> w >>> (x      /-
== y) & a & b ^ c | d ^ e | f & a && b ^^ c || d ^^ e || f += h **= l, (m+n)*o)
");
		scope exp = parser.parseExpression();
		writeln(exp.recoverCode(true));
	}
}