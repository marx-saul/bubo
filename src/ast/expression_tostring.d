module ast.expression_tostring;

import ast.expression;
import decoration;
import token;
import visitor.general;

string recoverCode(Expression exp, bool all_paren = false) {
	scope etsv = new ExpressionToStringVisitor(all_paren);
	if (exp) exp.accept(etsv);
	return etsv.result;
}

class ExpressionToStringVisitor : GeneralVisitor {
	string result;
	alias visit = GeneralVisitor.visit;
	
	bool all_paren;
	this (bool all_paren) {
		this.all_paren = all_paren;
	}
	
	void lparen(Expression exp) {
		if (exp)
			if (all_paren || exp.paren) result ~= "(";
	}
	void rparen(Expression exp) {
		if (exp)
			if (all_paren || exp.paren) result ~= ")";
	}
	void _accept(Expression exp) {
		if (exp) exp.accept(this);
		else result ~= "__error__";
	}
	
	override void visit(Expression exp) { assert(0, "ExpressionToStringVisitor" ~ typeid(exp).toString().decorate(DECO.reverse)); }
	override void visit(ErrorExpression exp) {
		result ~= "__error__";
	}
	override void visit(UnaryExpression exp) {
		lparen(exp);
		if (exp) {
			result ~= token_dictionary[exp.op];
			_accept(exp.next);
		}
		rparen(exp);
	}
	override void visit(PostDecExpression exp) {
		lparen(exp);
		if (exp) {
			_accept(exp.next);
			result ~= "--";
		}
		rparen(exp);
	}
	override void visit(PostIncExpression exp) {
		lparen(exp);
		if (exp) {
			_accept(exp.next);
			result ~= "++";
		}
		rparen(exp);
	}
	override void visit(CallExpression exp) {
		lparen(exp);
		if (exp) {
			_accept(exp.func);
			result ~= "(";
			foreach (param; exp.params) {
				_accept(param);
				result ~= ", ";
			}
			if (exp.params.length > 0) result.length -= 2;
			result ~= ")";
		}
		rparen(exp);
	}
	override void visit(IndexExpression exp) {
		lparen(exp);
		if (exp) {
			_accept(exp.next);
			result ~= "[";
			foreach (param; exp.params) {
				_accept(param);
				result ~= ", ";
			}
			if (exp.params.length > 0) result.length -= 2;
			result ~= "]";
		}
		rparen(exp);
	}
	override void visit(SliceExpression exp) {
		lparen(exp);
		if (exp) {
			_accept(exp.next);
			result ~= "[";
			foreach (i; 0 .. exp.params1.length) {
				_accept(exp.params1[i]);
				result ~= "..";
				_accept(exp.params2[i]);
				result ~= ", ";
			}
			if (exp.params1.length > 0) result.length -= 2;
			result ~= "]";
		}
		rparen(exp);
	}
	override void visit(BinaryExpression exp) {
		lparen(exp);
		if (exp) {
			_accept(exp.left);
			result ~= " " ~ token_dictionary[exp.op] ~ " ";
			_accept(exp.right);
		}
		rparen(exp);
	}
	override void visit(BinaryAssignExpression exp) {
		lparen(exp);
		if (exp) {
			_accept(exp.left);
			result ~= " " ~ token_dictionary[exp.op] ~ "= ";
			_accept(exp.right);
		}
		rparen(exp);
	}
	override void visit(WhenElseExpression exp)	{
		lparen(exp);
		if (exp) {
			result ~= "when ";
			_accept(exp.cond);
			result ~= ": ";
			_accept(exp.next1);
			result ~= " else ";
			_accept(exp.next2);
		}
		rparen(exp);
	}
	override void visit(TupleExpression exp) {
		lparen(exp);
		if (exp) {
			result ~= "(";
			foreach (elem; exp.elems) {
				_accept(elem);
				result ~= ", ";
			}
			if (exp.elems.length > 0) result.length -= 2;
			result ~= ")";
		}
		rparen(exp);
	}
	override void visit(ArrayExpression exp) {
		lparen(exp);
		if (exp) {
			result ~= "[";
			foreach (elem; exp.elems) {
				_accept(elem);
				result ~= ", ";
			}
			if (exp.elems.length > 0) result.length -= 2;
			result ~= "]";
		}
		rparen(exp);
	}
	override void visit(AssocArrayExpression exp) {
		lparen(exp);
		if (exp) {
			result ~= "[";
			foreach (i; 0 .. exp.keys.length) {
				_accept(exp.keys[i]);
				result ~= ": ";
				_accept(exp.values[i]);
				result ~= ", ";
			}
			if (exp.keys.length > 0) result.length -= 2;
			result ~= "]";
		}
		rparen(exp);
	}
	override void visit(RecordExpression exp) {
		lparen(exp);
		result ~= "{";
		if (exp) {
			foreach (n, e; exp.record) {
				result ~= n ~ ":";
				if (e) e.accept(this);
				result ~= ", ";
			}
			if (exp.record.length > 0) result.length -= 2;
		}
		result ~= "}";
		rparen(exp);
	}
	override void visit(IntegerExpression exp) {
		if (exp) result ~= exp.str;
	}
	override void visit(RealNumberExpression exp) {
		if (exp) result ~= exp.str;
	}
	override void visit(StringExpression exp) {
		if (exp) result ~= "`" ~ exp.str ~ "`";
	}
	override void visit(IdentifierExpression exp) {
		if (exp) {
			if (exp.is_global) result ~= ".";
			result ~= exp.id.name;
		}
	}
	override void visit(AnyExpression exp) {
		result ~= "_";
	}
	override void visit(FalseExpression exp) {
		result ~= "false";
	}
	override void visit(TrueExpression exp) {
		result ~= "true";
	}
	override void visit(NullExpression exp) {
		result ~= "null";
	}
	override void visit(ThisExpression exp) {
		result ~= "this";
	}
	override void visit(SuperExpression exp) {
		result ~= "super";
	}
	override void visit(DollarExpression exp) {
		result ~= "$";
	}
}