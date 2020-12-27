module ast.type_tostring;

import ast.type;
import decoration;
import token;
import visitor.general;

string recoverCode(Type type, bool all_paren = false) {
	scope ttsv = new TypeToStringVisitor(all_paren);
	if (type) type.accept(ttsv);
	return ttsv.result;
}

class TypeToStringVisitor : GeneralVisitor {
	string result;
	alias visit = GeneralVisitor.visit;
	
	bool all_paren;
	this (bool all_paren) {
		this.all_paren = all_paren;
	}
	
	void lparen(Type type) {
		if (type)
			if (all_paren || type.paren) result ~= "(";
	}
	void rparen(Type type) {
		if (type)
			if (all_paren || type.paren) result ~= ")";
	}
	void _accept(Type type) {
		if (type) type.accept(this);
		else result ~= "__error_type__";
	}
	
	override void visit(Type type) { assert(0, "TypeToStringVisitor" ~ typeid(type).toString().decorate(DECO.reverse)); }
	override void visit(ErrorType type) {
		result ~= "__error_type__";
	}
	override void visit(BasicType type) {
		import std.conv: to;
		
		with (TokenKind)
		switch (type.kind) {
		case void_:			result ~= "void";			break;
		case bool_:			result ~= "bool";			break;
		case char_:			result ~= "char";			break;
		case string_:		result ~= "string";			break;
		default:
			result ~= type.kind.to!string;
			break;
		}
	}
	override void visit(NextType type)					{ assert(0); }
	override void visit(DotIdentifierType type) {
		lparen(type);
		if (type) {
			_accept(type.next);
			result ~= "." ~ type.id.name;
		}
		rparen(type);
	}
	/*override void visit(DotInstanceType x) {
		lparen(type);
		rparen(type);
	}*/
	override void visit(ArrayType type) {
		if (type) {
			result ~= "[";
			_accept(type.next);
			result ~= "]";
		}
	}
	override void visit(AssocArrayType type) {
		if (type) {
			result ~= "[";
			_accept(type.key);
			result ~= ": ";
			_accept(type.value);
			result ~= "]";
		}
	}
	override void visit(PointerType type) {
		lparen(type);
		if (type) {
			result ~= "*";
			_accept(type.next);
		}
		rparen(type);
	}
	override void visit(LazyType type) {
		lparen(type);
		if (type) {
			result ~= "lazy ";
			_accept(type.next);
		}
		rparen(type);
	}
	override void visit(IndexType type) {
		lparen(type);
		if (type) {
			_accept(type.next);
			result ~= "[";
			import ast.expression_tostring : recoverCode;
			result ~= recoverCode(type.exp);
			result ~= "]";
		}
		rparen(type);
	}
	override void visit(SliceType type) {
		lparen(type);
		if (type) {
			_accept(type.next);
			result ~= "[";
			import ast.expression_tostring : recoverCode;
			result ~= recoverCode(type.exp1);
			result ~= "..";
			result ~= recoverCode(type.exp2);
			result ~= "]";
		}
		rparen(type);
	}
	override void visit(TupleType type) {
		if (type) {
			result ~= "(";
			foreach (elem; type.elems) {
				_accept(elem);
				result ~= ", ";
			}
			if (type.elems.length > 0) result.length -= 2;
			result ~= ")";
		}
	}
	override void visit(RecordType type) {
		result ~= "{";
		if (type) {
			foreach (n, t; type.record) {
				result ~= n ~ ":";
				if (t) t.accept(this);
				result ~= ", ";
			}
			if (type.record.length > 0) result.length -= 2;
		}
		result ~= "}";
	}
	override void visit(FunctionType type) {
		lparen(type);
		if (type) {
			result ~= "(";
			foreach (param; type.params) {
				_accept(param);
				result ~= ", ";
			}
			if (type.params.length > 0) result.length -= 2;
			result ~= ") -> ";
			_accept(type.ret);
		}
		rparen(type);
	}
	override void visit(NullType type) {
		result ~= "__null__";
	}
	override void visit(TypeofType type) {
		result ~= "typeof";
	}
	override void visit(IdentifierType type) {
		result ~= type.id.name;
	}
	/*override void visit(InstanceType x) {
		lparen(type);
		rparen(type);
	}*/
}