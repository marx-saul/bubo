module ast.expression;

import ast.astnode;
import ast.type;
import identifier;
import token;
import visitor.expression;
import visitor.visitor;

/// Expression class
abstract class Expression : ASTNode {
	Location loc;	/// the location of this node
	bool paren;		/// is this expression parenthesized 
	this(Location loc, bool paren=false) {
		this.loc = loc;
		this.paren = paren;
	}
	
	Type type;		/// type of this expression
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// op a
abstract class UnaryExpression : Expression {
	TokenKind op;
	Expression next;
	this(Location loc, TokenKind op, Expression next, bool paren=false) {
		super(loc, paren);
		this.op = op;
		this.next = next;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// +a
final class PlusExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.add, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// -a
final class MinusExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.sub, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// ++a
final class PreIncExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.inc, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// --a
final class PreDecExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.dec, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// &a
final class RefExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.and, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// *a
final class DerefExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.mul, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// !a
final class NotExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.exclam, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// ~a
final class ComplementExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.exclam, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a++
final class PostIncExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.inc, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a++
final class PostDecExpression : UnaryExpression {
	this(Location loc, Expression next, bool paren = false) {
		super(loc, TokenKind.inc, next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a(b, c, d, ...)
final class CallExpression : Expression {
	Expression func;
	Expression[] params;
	this(Location loc, Expression func, Expression[] params, bool paren = false) {
		super(loc, paren);
		this.func = func;
		this.params = params;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a[b, c, d, ...]
final class IndexExpression : Expression {
	Expression func;
	Expression[] params;
	this(Location loc, Expression func, Expression[] params, bool paren = false) {
		super(loc, paren);
		this.func = func;
		this.params = params;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a[b .. c, d .. e, f .. g, ...]
final class SliceExpression : Expression {
	Expression func;
	Expression[] params1;
	Expression[] params2;
	this(Location loc, Expression func, Expression[] params1, Expression[] params2, bool paren = false) {
		super(loc, paren);
		this.func = func;
		this.params1 = params1;
		this.params2 = params2;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a op b
abstract class BinaryExpression : Expression {
	Expression left;
	TokenKind op;
	Expression right;
	this(Location loc, Expression left, TokenKind op, Expression right, bool paren=false) {
		super(loc, paren);
		this.left = left;
		this.op = op;
		this.right = right;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a = b
final class AssignExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.ass, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a op= b
abstract class BinaryAssignExpression : BinaryExpression {
	this(Location loc, Expression left, TokenKind op, Expression right, bool paren = false) {
		super(loc, left, op, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a &= b
final class AndAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.and, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a ^= b
final class XorAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.xor, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a |= b
final class OrAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.or, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a <<= b
final class LShiftAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.lshift, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a >>= b
final class RShiftAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.rshift, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a >>>= b
final class LogicalShiftAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.logical_shift, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a += b
final class AddAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.add, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a -= b
final class SubAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.sub, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a ~= b
final class CatAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.tilde, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a *= b
final class MulAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.mul, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a /= b
final class DivAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.div, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a %= b
final class ModAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.mod, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a **= b
final class PowAssignExpression : BinaryAssignExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.pow, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a |> b
final class PipelineExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.pipeline, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a || b
final class OrOrExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.oror, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a ^^ b
final class XorXorExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.xorxor, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a && b
final class AndAndExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.andand, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}


/// a | b
final class OrExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.or, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a ^ b
final class XorExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.xor, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a & b
final class AndExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.and, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a is b   a !is b
final class IdentityExpression : BinaryExpression {
	bool not;
	this(Location loc, Expression left, bool not, Expression right, bool paren = false) {
		super(loc, left, TokenKind.is_, right, paren);
		this.not = not;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a in b   a !in b
final class InExpression : BinaryExpression {
	bool not;
	this(Location loc, Expression left, bool not, Expression right, bool paren = false) {
		super(loc, left, TokenKind.in_, right, paren);
		this.not = not;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a < b
final class LsExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.ls, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a <= b
final class LeqExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.leq, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a > b
final class GtExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.gt, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a >= b
final class GeqExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.geq, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a == b   a != b
final class EqExpression : BinaryExpression {
	bool not;
	this(Location loc, Expression left, bool not, Expression right, bool paren = false) {
		super(loc, left, TokenKind.eq, right, paren);
		this.not = not;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a << b
final class LShiftExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.lshift, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a >> b
final class RShiftExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.rshift, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a >>> b
final class LogicalShiftExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.logical_shift, right);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a + b
final class AddExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.add, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a - b
final class SubExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.sub, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a ~ b
final class CatExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.tilde, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a * b
final class MulExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.mul, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a / b
final class DivExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.div, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a % b
final class ModExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.mod, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a ** b
final class PowExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.pow, right, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a.b
final class DotExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.dot, right, paren);
		this.left = left;
		this.right = right;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// when a : b else c
final class WhenElseExpression : Expression {
	Expression condition;
	Expression next1;
	Expression next2;
	this(Location loc, Expression condition, Expression next1, Expression next2, bool paren = false) {
		super(loc, paren);
		this.condition = condition;
		this.next1 = next1;
		this.next2 = next2;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// (a, b, c, ...)
final class TupleExpression : Expression {
	Expression[] elems;
	this(Location loc, Expression[] elems, bool paren = false) {
		super(loc, paren);
		this.elems = elems;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// [a, b, c, ...]
final class ArrayExpression : Expression {
	Expression[] elems;
	this(Location loc, Expression[] elems, bool paren = false) {
		super(loc, paren);
		this.elems = elems;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// [a:b, c:d, d:e, ...]
final class AssocArrayExpression : Expression {
	Expression[] keys;
	Expression[] values;
	this(Location loc, Expression[] keys, Expression[] values, bool paren = false) {
		super(loc, paren);
		this.keys = keys;
		this.values = values;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// 42  0x10_001
final class IntegerExpression : Expression {
	string str;
	this(Location loc, string str, bool paren = false) {
		super(loc, paren);
		this.str = str;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// 123.456  3.1415
final class RealNumberExpression : Expression {
	string str;						/// the string of this real number literal

	this(Location loc, string str, bool paren = false) {
		super(loc, paren);
		this.str = str;
	}
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// "hello"  `hey`
final class StringExpression : Expression {
	string str;						/// the string literal it self, if the token is "hello", then str is "hello", not "\"hello\""
	
	this(Location loc, string str, bool paren = false) {
		super(loc, paren);
		this.str = str;
	}
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// stack  i   .num
final class IdentifierExpression : Expression {
	Identifier id;					/// identifier 
	bool is_global;					/// . Identifier
	
	this(Identifier id, bool is_global, bool paren = false) {
		super(id.loc);
		this.id = id;
		this.is_global = is_global;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// _
final class AnyExpression : Expression {
	this(Location loc) {
		super(loc);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// false
final class FalseExpression : Expression {
	this(Location loc) {
		super(loc);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// true
final class TrueExpression : Expression {
	this(Location loc) {
		super(loc);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// null
final class NullExpression : Expression {
	this(Location loc) {
		super(loc);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// this
final class ThisExpression : Expression {
	this(Location loc) {
		super(loc);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// super
final class SuperExpression : Expression {
	this(Location loc) {
		super(loc);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// $
final class DollarExpression : Expression {
	this(Location loc) {
		super(loc);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}