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
		error(loc, token_dictionary[kind].decorate(DECO.source_code), " was expected, not ", token_dictionary[err_kind].decorate(DECO.source_code));
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
	
	Expression parseAssignExpression()
	out (result) {
		assert(result);		// this does not returns null
	}
	do {
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
		auto e1 = parseArrowExpression();
		loop:
		while (true) {
			auto loc = token.loc;
			with (TokenKind)
			switch (token.kind) {
			case mul:
				nextToken();	// get rid of *
				auto e2 = parseArrowExpression();
				e1 = new MulExpression(loc, e1, e2);
				break;
				
			case div:
				nextToken();	// get rid of /
				auto e2 = parseArrowExpression();
				e1 = new DivExpression(loc, e1, e2);
				break;
			
			case mod:
				nextToken();	// get rid of %
				auto e2 = parseArrowExpression();
				e1 = new ModExpression(loc, e1, e2);
				break;
				
			default: break loop;
			}
		}
		
		return e1;
	}
	
	Expression parseArrowExpression() {
		auto e1 = parseUnaryExpression();
		
		if (token.kind == TokenKind.arrow) {
			auto loc = token.loc;
			nextToken();	// get rid of ->
			auto e2 = parseArrowExpression();
			e1 = new ArrowExpression(loc, e1, e2);
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
							auto e2 = new IdentifierExpression(token.id, false);
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
				result = new IdentifierExpression(token.id, false);
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
					result = new IdentifierExpression(token.id, true);
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
		
		case lbrace:
			return parseRecordExpression();
			
		case new_:
			return parseNewExpression();
		
		case when:
			return parseWhenElseExpression();
		
		case int8:
		case int16:
		case int32:
		case int64:
		case uint8:
		case uint16:
		case uint32:
		case uint64:
		case real32:
		case real64:
		case char_:
		case string_:
		case bool_:
		case void_:
			auto type = new BasicType(token.kind);
			auto loc = token.loc;
			nextToken();
			return new TypeExpression(loc, type);
		
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
			nextToken();
			result = new ErrorExpression(token.loc);
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
			if (!elems[0]) elems[0] = new ErrorExpression(token.loc);
			else elems[0].paren = true;
			return elems[0];
		}
	}
	
	Expression parseArrayExpression() {
		auto loc = token.loc;
		check(TokenKind.lbracket);
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
	
	Expression parseRecordExpression() {
		auto loc = token.loc;
		check(TokenKind.lbrace);
		
		Expression[string] record;
		if (token.kind == TokenKind.rbrace) {
			nextToken();	// get rid of }
			return new RecordExpression(loc, record);
		}
		
		with (TokenKind)
		while (token.kind == identifier) {
			const name = token.str;
			const loc2 = token.loc;
			nextToken();	// get rid of Identifier
			check(TokenKind.colon);
			auto exp = parseExpression(); // @suppress(dscanner.suspicious.unmodified)
			
			if (name in record)
				this.error(loc2, "Record name '" ~ name.decorate(DECO.source_code) ~ "' has already appeared.");
			else
				record[name] = exp;
			
			if (token.kind == comma) {
				nextToken();
				if (token.kind == rbrace) break;
				else continue;
			}
			else break;
		}
		check(TokenKind.rbrace);
		return new RecordExpression(loc, record);
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
	
	Expression parseWhenElseExpression() {
		auto loc = token.loc;
		check(TokenKind.when);	// get rid of when
		auto cond = parseExpression();
		check(TokenKind.colon);
		auto when_exp = parseExpression();
		check(TokenKind.else_);
		auto else_exp = parseExpression();
		return new WhenElseExpression(loc, cond, when_exp, else_exp);
	}
	
	Expression[] parseExpressions() {
		auto result = [parseExpression()];
		while (token.kind == TokenKind.comma) {
			nextToken();	// get rid of ,
			result ~= parseExpression();
		}
		return result;
	}
	
	pure @property bool isFirstOfExpression(TokenKind kind) {
		with (TokenKind)
		switch (kind) {
		case false_:
		case true_:
		case null_:
		case this_:
		case super_:
		case dollar:	// error
		case any:
		case integer:
		case real_number:
		case string_literal:
		case add:
		case inc:
		case sub:
		case dec:
		case mul:
		case and:
		case exclam:
		case tilde:
		case dot:
		case lparen:
		case lbracket:
		case lbrace:
		case new_:
		case when:
		case int8:
		case int16:
		case int32:
		case int64:
		case uint8:
		case uint16:
		case uint32:
		case uint64:
		case real32:
		case real64:
		case char_:
		case string_:
		case bool_:
		case void_:
		//case typeid_:
		//case typeof_:
		//case lambda:
		//case assert_:
		case identifier:
		//case mixin_:
		//case import_:
			return true;
			
		default:
			return false;
		}
	}
	
	/***********************************************************************************************************
	 * Type
	 */
	alias parseType = parseFunctionType;
	
	Type parseFunctionType()
	out (result) {
		assert(result);		// this does not returns null
	}
	do {
		auto t1 = parseUnaryType();
		
		if (token.kind == TokenKind.arrow) {
			nextToken();	// get rid of ->
			auto t2 = parseUnaryType();
			bool flag;
			if (t1)
				if (auto tuple_type = t1.isTupleType)
					if (!tuple_type.paren) {
							t1 = new FunctionType(tuple_type.elems, t2);
							flag = true;
					}
			if (!flag) t1 = new FunctionType([t1], t2);
		}
		
		return t1;
	}
	
	Type parseUnaryType() {
		with (TokenKind)
		switch (token.kind) {
		case mul:
			nextToken();	// get rid of *
			auto t2 = parseUnaryType();
			return new PointerType(t2);
		//case const_:
		//case immut_:
		//case inout_:
		//case shared_:
		case lazy_:
			nextToken();	// get rid of lazy
			auto t2 = parseUnaryType();
			return new LazyType(t2);
		
		default:
			return parsePostfixType();
		}
	}
	
	Type parsePostfixType() {
		auto t1 = parsePrimaryType();
		
		loop:
		while (true) {
			with (TokenKind)
			switch (token.kind) {
			case dot:
				while (token.kind == dot) {
					nextToken();	// get rid of .
					if (token.kind == identifier) {
						// template instance
						if (lookahead().kind == exclam) {
							assert(0, "has not been implemented yet");
							//to do
						}
						else {
							auto id = Identifier(token.loc, token.str);
							nextToken();	// get rid of Identifier
							t1 = new DotIdentifierType(t1, id);
						}
					}
					else {
						this.error(token.loc,
							"An identifier or ", "new".decorate(DECO.source_code),
							" was expected after " ~  ".".decorate(DECO.source_code),
							", not " ~ token.str.decorate(DECO.source_code) ~ "."
							);
					}
				}
				break;
				
			case lbracket:
				nextToken();	// get rid of [
				auto e1 = parseExpression();
				if (token.kind == dotdot) {
					nextToken();	// get rid of ..
					auto e2 = parseExpression();
					check(TokenKind.rbracket);
					t1 = new SliceType(t1, e1, e2);
				}
				else {
					check(TokenKind.rbracket);
					t1 = new IndexType(t1, e1);
				}
				break;
			
			default: break loop;
			}
		}
		
		return t1;
	}
	
	Type parsePrimaryType() {
		with (TokenKind)
		switch (token.kind) {
		case int8:
		case int16:
		case int32:
		case int64:
		case uint8:
		case uint16:
		case uint32:
		case uint64:
		case real32:
		case real64:
		case char_:
		case string_:
		case bool_:
		case void_:
			auto kind = token.kind;
			nextToken();
			return new BasicType(kind);
			
		case dot:
			nextToken();	// get rid of .
			if (token.kind == identifier) {
				if (lookahead().kind == exclam) {
					assert(0, "has not implemented yet");
				}
				else {
					auto id = Identifier(token.loc, token.str);
					nextToken();	// get rid of identifier
					return new IdentifierType(id, true);
				}
			}
			else {
				this.error(token.loc,
					"An identifier was expected after " ~  ".".decorate(DECO.source_code),
					", not " ~ token.str.decorate(DECO.source_code) ~ "."
				);
				return new ErrorType(token.loc);
			}
			
		case identifier:
			if (lookahead().kind == exclam) {
				assert(0, "has not been implemented yet.");
			}
			else {
				auto id = Identifier(token.loc, token.str);
				nextToken();
				return new IdentifierType(id, false);
			}
			
		case lparen:
			return parseTupleType();
			
		case lbracket:
			return parseArrayType();
		
		case lbrace:
			return parseRecordType();
			
		//case typeof_:
			//return parseTypeofType();
		
		default:
			this.error(token.loc,
				"A type was expected, not " ~ token.str.decorate(DECO.source_code) ~ "."
			);
			nextToken();
			return new ErrorType(token.loc);
		}
	}
	
	Type parseTupleType() {
		auto loc = token.loc;
		check(TokenKind.lparen);
		auto elems = parseTypes();
		if (token.kind == TokenKind.comma) nextToken();	// get rid of ,
		check(TokenKind.rparen);
		
		if (elems.length > 1) {
			return new TupleType(elems);
		}
		else {
			if (!elems[0]) elems[0] = new ErrorType(token.loc);
			else elems[0].paren = true;
			return elems[0];
		}
	}
	
	Type parseArrayType() {
		check(TokenKind.lbracket);
		auto t1 = parseType();
		if (token.kind == TokenKind.colon) {
			nextToken();	// get rid of :
			auto t2 = parseType();
			check(TokenKind.rbracket);
			return new AssocArrayType(t1, t2);
		}
		else {
			check(TokenKind.rbracket);
			return new ArrayType(t1);
		}
	}
	
	Type parseRecordType() {
		check(TokenKind.lbrace);
		
		Type[string] record;
		if (token.kind == TokenKind.rbrace) {
			nextToken();	// get rid of }
			return new RecordType(record);
		}
		
		with (TokenKind)
		while (token.kind == identifier) {
			const name = token.str;
			const loc2 = token.loc;
			nextToken();	// get rid of Identifier
			check(TokenKind.colon);
			auto type = parseType(); // @suppress(dscanner.suspicious.unmodified)
			
			if (name in record)
				this.error(loc2, "Record name '" ~ name.decorate(DECO.source_code) ~ "' has already appeared.");
			else
				record[name] = type;
			
			if (token.kind == comma) {
				nextToken();
				if (token.kind == rbrace) break;
				else continue;
			}
			else break;
		}
		check(TokenKind.rbrace);
		return new RecordType(record);
	}
	
	Type[] parseTypes() {
		auto result = [parseType()];
		while (token.kind == TokenKind.comma) {
			nextToken();	// get rid of ,
			result ~= parseType();
		}
		return result;
	}
	
	
	/***********************************************************************************************************
	 * Statement
	 */
	private void checkStmtEnd() {
		if (token.kind == TokenKind.semicolon) {
			nextToken();
			if (token.kind == TokenKind.new_line) {
				nextToken();
			}
		}
		else if (token.kind == TokenKind.new_line) {
			nextToken();
		}
		else {
			error(token.loc,
				"Found ", token_dictionary[token.kind].decorate(DECO.source_code),
				" when expecting ", ";".decorate(DECO.source_code), " or a new line."
			);
		}
	}
	Statement parseStatement()
	out (result) {
		assert(result);		// this never returns null
	}
	do {
		with (TokenKind)
		if (token.kind == dollar) {
			auto loc = token.loc;
			nextToken();	// get rid of $
			auto id = Identifier(loc, token.str);
			if (token.kind != identifier) {
				this.error(token.loc, "An identifier was expected, not ", token_dictionary[token.kind].decorate(DECO.source_code));
				return new ErrorStatement(token.loc);
			}
			else {
				nextToken();	// get rid of identifier
				assert(0);
				//return new LabelStatement(loc, id);
			}
		}
		else if (isFirstOfExpression(token.kind)) {
			auto loc = token.loc;
			auto expr = parseExpression();
			checkStmtEnd();
			return new ExpressionStatement(loc, expr);
		}
		else {
			Statement stmt;
			auto loc = token.loc;
			switch (token.kind) {
			case break_:
				stmt = parseBreakStatement();
				break;
				
			case continue_:
				stmt = parseContinueStatement();
				break;
				
			case do_:
				stmt = parseDoWhileStatement();
				break;
				
			case for_:
				stmt = parseForStatement();
				break;
				
			case goto_:
				stmt = parseGotoStatement();
				break;
				
			case if_:
				stmt = parseIfElseStatement();
				break;
				
			case return_:
				stmt = parseReturnStatement();
				break;
				
			case scope_:
				stmt = parseScopeStatement();
				break;
			
			case while_:
				stmt = parseWhileStatement();
				break;
				
			default:
				this.error(loc,
					"A statement was expected, not " ~ token.str.decorate(DECO.source_code) ~ "."
				);
				nextToken();
				return new ErrorStatement(loc);
			}
			
			if (stmt) return stmt;
			else return new ErrorStatement(loc);
		}
	}
	
	BreakStatement parseBreakStatement() {
		auto loc = token.loc;
		check(TokenKind.break_);
		Identifier id;
		if (token.kind == TokenKind.identifier) {
			id = token.id;
			nextToken();	// get rid of identifier
		}
		checkStmtEnd();
		return new BreakStatement(loc, id);
	}
	
	ContinueStatement parseContinueStatement() {
		auto loc = token.loc;
		check(TokenKind.continue_);
		Identifier id;
		if (token.kind == TokenKind.identifier) {
			id = token.id;
			nextToken();	// get rid of identifier
		}
		checkStmtEnd();
		return new ContinueStatement(loc, id);
	}
	
	DoWhileStatement parseDoWhileStatement() {
		auto loc = token.loc;
		check(TokenKind.do_);
		auto _body = parseCompoundStatement();
		check(TokenKind.while_);
		auto cond = parseExpression();
		checkStmtEnd();
		return new DoWhileStatement(loc, _body, cond);
	}
	
	ForStatement parseForStatement() {
		auto loc = token.loc;
		check(TokenKind.for_);
		bool is_let;
		if (token.kind == TokenKind.let) {
			is_let = true;
			nextToken();
		}
		Expression _init;
		if (isFirstOfExpression(token.kind))
			_init = parseExpression();
		Expression cond;
		check(TokenKind.semicolon);
		if (isFirstOfExpression(token.kind))
			cond = parseExpression();
		check(TokenKind.semicolon);
		Expression exec;
		if (isFirstOfExpression(token.kind))
			exec = parseExpression();
		auto _body = parseCompoundStatement();
		checkStmtEnd();
		return new ForStatement(loc, is_let, _init, cond, exec, _body);
	}
	
	GotoStatement parseGotoStatement() {
		auto loc = token.loc;
		check(TokenKind.goto_);
		auto label = token.id;
		if (token.kind == TokenKind.identifier) {
			return new GotoStatement(loc, label);
		}
		else {
			error(loc, "An identifier of a label was expected after " ~ "goto".decorate(DECO.source_code));
			return null;
		}
	}
	
	IfElseStatement parseIfElseStatement() {
		auto loc = token.loc;
		check(TokenKind.if_);
		/+
		Identifier id;
		Type type;
		if (token.kind == TokenKind.let) {
			nextToken();	// get rid of let
			if (token.kind != TokenKind.identifier) {
				this.error(token.loc,
					"An identifier was expected after ", "if let".decorate(DECO.source_code),
					", not", token_dictionary[token.kind].decorate(DECO.source_code)
				);
				return null;
			}
			else {
				id = token.id;
				nextToken();	// get rid of identifier
			}
			
			if (token.kind == TokenKind.colon) {
				nextToken();	// get rid of :
				type = parseType();
			}
			
			check(TokenKind.ass);
		}
		+/
		bool is_let;
		if (token.kind == TokenKind.let) {
			is_let = true;
			nextToken();
		}
		auto cond = parseExpression();
		check(TokenKind.colon);
		auto if_stmt = parseCompoundStatement();
		
		CompoundStatement else_stmt;
		if (token.kind == TokenKind.else_) {
			nextToken();	// get rid of else
			else_stmt = parseCompoundStatement();
		}
		
		return new IfElseStatement(loc, is_let, cond, if_stmt, else_stmt);
	}
	
	ReturnStatement parseReturnStatement() {
		auto loc = token.loc;
		check(TokenKind.return_);
		Expression expr;
		if (isFirstOfExpression(token.kind)) {
			expr = parseExpression();
		}
		checkStmtEnd();
		return new ReturnStatement(loc, expr);
	}
	
	ScopeStatement parseScopeStatement() {
		auto loc = token.loc;
		check(TokenKind.scope_);
		
		SSKind sskind;
		switch (token.str) {
		case "exit":
			sskind = SSKind.exit;
			nextToken();
			break;
			
		case "failure":
			sskind = SSKind.failure;
			nextToken();
			break;
			
		case "return":
			sskind = SSKind.return_;
			nextToken();
			break;
		
		case "success":
			sskind = SSKind.success;
			nextToken();
			break;
		
		default:
			sskind = SSKind.block;
			break;
		}
		
		auto _body = parseCompoundStatement();
		return new ScopeStatement(loc, sskind, _body);
	}
	
	CompoundStatement parseCompoundStatement() {
		// new indent
		if (token.kind == TokenKind.inc_indent) {
			auto loc = token.loc;
			nextToken();	// get rid of \t
			Statement[] stmts;
			while (isFirstOfStatement(token.kind)) {
				stmts ~= parseStatement();
			}
			check(TokenKind.dec_indent);
			return new CompoundStatement(loc, stmts);
		}
		// within one line
		else {
			auto loc = token.loc;
			Statement[] stmts;
			while (isFirstOfStatement(token.kind) && token.loc.line_num == loc.line_num) {
				stmts ~= parseStatement();
			}
			return new CompoundStatement(loc, stmts);
		}
	}
	
	WhileStatement parseWhileStatement() {
		auto loc = token.loc;
		check(TokenKind.while_);
		auto cond = parseExpression();
		auto _body = parseCompoundStatement();
		return new WhileStatement(loc, cond, _body);
	}
	
	pure @property bool isFirstOfStatement(TokenKind kind) {
		with(TokenKind)
		if (kind == dollar) {
			return true;
		}
		else if (isFirstOfExpression(kind)) {
			return true;
		}
		else {
			switch (kind) {
			case break_:
			case continue_:
			case do_:
			case for_:
			case goto_:
			case if_:
			case return_:
			case scope_:
			case while_:
				return true;
			default:
				return false;
			}
		}
	}
}

unittest {
	import std.stdio;
	import ast.expression_tostring;
	import ast.statement_tostring;
	import ast.type_tostring;
	writeln("parser".decorate(DECO.f_green));
	
	// expression
	{
		scope parser = new Parser!string("/-
a = (--b.c.d++(e, f)(g, g)[h][], --b.c.d++(e,f), a++(e,f), a++, a(e, f), a[e, f], a[], a + -b ** c -> d)
");
		scope exp = parser.parseExpression();
		writeln(exp.recoverCode(true));
	}
	
	// type
	{
		scope parser = new Parser!string("/-
{id1 : (int32 -> int32, int32) -> (int32 -> int32), id2 : /-
[({}, [*void -> {}])], id3 : *[*lazy*[a][10 .. 12]]}
");
		scope type = parser.parseType();
		writeln(type.recoverCode(true));
	}
	
	// statement
	{
		scope parser = new Parser!string(`scope
		print("hello world")
		//let fn = \(a:int, n:int) -> int
		count = 0
		result = 1
		while count < n
			result *= a
			result %= 65537
			++count
		return result
		zip(fn, [3, 5, 2, 16, 256, 4292], [5, 27, 8, 997, 1002, 12082]).print()
`);
		scope stmt = parser.parseStatement();
		writeln(stmt.recoverCode(true));
	}
	
}