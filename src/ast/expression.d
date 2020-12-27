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
	
	@nogc @safe @property inout {
		inout(ErrorExpression) isErrorExpression() { return null; }
		inout(UnaryExpression) isUnaryExpression() { return null; }
		inout(PlusExpression) isPlusExpression() { return null; }
		inout(MinusExpression) isMinusExpression() { return null; }
		inout(PreIncExpression) isPreIncExpression() { return null; }
		inout(PreDecExpression) isPreDecExpression() { return null; }
		inout(RefExpression) isRefExpression() { return null; }
		inout(DerefExpression) isDerefExpression() { return null; }
		inout(NotExpression) isNotExpression() { return null; }
		inout(ComplementExpression) isComplementExpression() { return null; }
		inout(PostIncExpression) isPostIncExpression() { return null; }
		inout(PostDecExpression) isPostDecExpression() { return null; }
		inout(CallExpression) isCallExpression() { return null; }
		inout(IndexExpression) isIndexExpression() { return null; }
		inout(SliceExpression) isSliceExpression() { return null; }
		inout(BinaryExpression) isBinaryExpression() { return null; }
		inout(AssignExpression) isAssignExpression() { return null; }
		inout(BinaryAssignExpression) isBinaryAssignExpression() { return null; }
		inout(AndAssignExpression) isAndAssignExpression() { return null; }
		inout(XorAssignExpression) isXorAssignExpression() { return null; }
		inout(OrAssignExpression) isOrAssignExpression() { return null; }
		inout(LShiftAssignExpression) isLShiftAssignExpression() { return null; }
		inout(RShiftAssignExpression) isRShiftAssignExpression() { return null; }
		inout(LogicalShiftAssignExpression) isLogicalShiftAssignExpression() { return null; }
		inout(AddAssignExpression) isAddAssignExpression() { return null; }
		inout(SubAssignExpression) isSubAssignExpression() { return null; }
		inout(CatAssignExpression) isCatAssignExpression() { return null; }
		inout(MulAssignExpression) isMulAssignExpression() { return null; }
		inout(DivAssignExpression) isDivAssignExpression() { return null; }
		inout(ModAssignExpression) isModAssignExpression() { return null; }
		inout(PowAssignExpression) isPowAssignExpression() { return null; }
		inout(PipelineExpression) isPipelineExpression() { return null; }
		inout(OrOrExpression) isOrOrExpression() { return null; }
		inout(XorXorExpression) isXorXorExpression() { return null; }
		inout(AndAndExpression) isAndAndExpression() { return null; }
		inout(OrExpression) isOrExpression() { return null; }
		inout(XorExpression) isXorExpression() { return null; }
		inout(AndExpression) isAndExpression() { return null; }
		inout(IdentityExpression) isIdentityExpression() { return null; }
		inout(InExpression) isInExpression() { return null; }
		inout(LsExpression) isLsExpression() { return null; }
		inout(LeqExpression) isLeqExpression() { return null; }
		inout(GtExpression) isGtExpression() { return null; }
		inout(GeqExpression) isGeqExpression() { return null; }
		inout(EqExpression) isEqExpression() { return null; }
		inout(LShiftExpression) isLShiftExpression() { return null; }
		inout(RShiftExpression) isRShiftExpression() { return null; }
		inout(LogicalShiftExpression) isLogicalShiftExpression() { return null; }
		inout(AddExpression) isAddExpression() { return null; }
		inout(SubExpression) isSubExpression() { return null; }
		inout(CatExpression) isCatExpression() { return null; }
		inout(MulExpression) isMulExpression() { return null; }
		inout(DivExpression) isDivExpression() { return null; }
		inout(ModExpression) isModExpression() { return null; }
		inout(ArrowExpression) isArrowExpression() { return null; }
		inout(PowExpression) isPowExpression() { return null; }
		inout(DotExpression) isDotExpression() { return null; }
		inout(WhenElseExpression) isWhenElseExpression() { return null; }
		inout(TupleExpression) isTupleExpression() { return null; }
		inout(ArrayExpression) isArrayExpression() { return null; }
		inout(AssocArrayExpression) isAssocArrayExpression() { return null; }
		inout(RecordExpression) isRecordExpression() { return null; }
		inout(TypeExpression) isTypeExpression() { return null; }
		inout(IntegerExpression) isIntegerExpression() { return null; }
		inout(RealNumberExpression) isRealNumberExpression() { return null; }
		inout(StringExpression) isStringExpression() { return null; }
		inout(IdentifierExpression) isIdentifierExpression() { return null; }
		inout(AnyExpression) isAnyExpression() { return null; }
		inout(FalseExpression) isFalseExpression() { return null; }
		inout(TrueExpression) isTrueExpression() { return null; }
		inout(NullExpression) isNullExpression() { return null; }
		inout(ThisExpression) isThisExpression() { return null; }
		inout(SuperExpression) isSuperExpression() { return null; }
		inout(DollarExpression) isDollarExpression() { return null; }
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

final class ErrorExpression : Expression {
	this(Location loc) {
		super(loc, false);
	}
	
	override @nogc @safe @property inout inout(ErrorExpression) isErrorExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
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
	
	override @nogc @safe @property inout inout(UnaryExpression) isUnaryExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(PlusExpression) isPlusExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(MinusExpression) isMinusExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(PreIncExpression) isPreIncExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(PreDecExpression) isPreDecExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(RefExpression) isRefExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(DerefExpression) isDerefExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(NotExpression) isNotExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(ComplementExpression) isComplementExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(PostIncExpression) isPostIncExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(PostDecExpression) isPostDecExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(CallExpression) isCallExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a[b, c, d, ...]
final class IndexExpression : Expression {
	Expression next;
	Expression[] params;
	this(Location loc, Expression next, Expression[] params, bool paren = false) {
		super(loc, paren);
		this.next = next;
		this.params = params;
	}
	
	override @nogc @safe @property inout inout(IndexExpression) isIndexExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a[b .. c, d .. e, f .. g, ...]
final class SliceExpression : Expression {
	Expression next;
	Expression[] params1;
	Expression[] params2;
	this(Location loc, Expression next, Expression[] params1, Expression[] params2, bool paren = false) {
		super(loc, paren);
		this.next = next;
		this.params1 = params1;
		this.params2 = params2;
	}
	
	override @nogc @safe @property inout inout(SliceExpression) isSliceExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(BinaryExpression) isBinaryExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(AssignExpression) isAssignExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a op= b
abstract class BinaryAssignExpression : Expression {
	Expression left;
	TokenKind op;
	Expression right;
	this(Location loc, Expression left, TokenKind op, Expression right, bool paren = false) {
		super(loc, paren);
		this.left = left;
		this.op = op;
		this.right = right;
	}
	
	override @nogc @safe @property inout inout(BinaryAssignExpression) isBinaryAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(AndAssignExpression) isAndAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(XorAssignExpression) isXorAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(OrAssignExpression) isOrAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(LShiftAssignExpression) isLShiftAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(RShiftAssignExpression) isRShiftAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(LogicalShiftAssignExpression) isLogicalShiftAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(AddAssignExpression) isAddAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(SubAssignExpression) isSubAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(CatAssignExpression) isCatAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(MulAssignExpression) isMulAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(DivAssignExpression) isDivAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(ModAssignExpression) isModAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(PowAssignExpression) isPowAssignExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(PipelineExpression) isPipelineExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(OrOrExpression) isOrOrExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(XorXorExpression) isXorXorExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(AndAndExpression) isAndAndExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(OrExpression) isOrExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(XorExpression) isXorExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(AndExpression) isAndExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(IdentityExpression) isIdentityExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(InExpression) isInExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(LsExpression) isLsExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(LeqExpression) isLeqExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(GtExpression) isGtExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(GeqExpression) isGeqExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(EqExpression) isEqExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(LShiftExpression) isLShiftExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(RShiftExpression) isRShiftExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(LogicalShiftExpression) isLogicalShiftExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(AddExpression) isAddExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(SubExpression) isSubExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(CatExpression) isCatExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(MulExpression) isMulExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(DivExpression) isDivExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(ModExpression) isModExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// a -> b (not an expression but a type)
final class ArrowExpression : BinaryExpression {
	this(Location loc, Expression left, Expression right, bool paren = false) {
		super(loc, left, TokenKind.arrow, right, paren);
	}
	
	override @nogc @safe @property inout inout(ArrowExpression) isArrowExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(PowExpression) isPowExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(DotExpression) isDotExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// when a : b else c
final class WhenElseExpression : Expression {
	Expression cond;
	Expression next1;
	Expression next2;
	this(Location loc, Expression cond, Expression next1, Expression next2, bool paren = false) {
		super(loc, paren);
		this.cond = cond;
		this.next1 = next1;
		this.next2 = next2;
	}
	
	override @nogc @safe @property inout inout(WhenElseExpression) isWhenElseExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(TupleExpression) isTupleExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(ArrayExpression) isArrayExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(AssocArrayExpression) isAssocArrayExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// {id1:b, id2:d, ...}
final class RecordExpression : Expression {
	Expression[string] record;
	this(Location loc, Expression[string] record, bool paren = false) {
		super(loc, paren);
		this.record = record;
	}
	
	override @nogc @safe @property inout inout(RecordExpression) isRecordExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}

/// int32, string -> string
final class TypeExpression : Expression {
	Type type;
	this(Location loc, Type type, bool paren = false) {
		super(loc, paren);
		this.type = type;
	}
	
	override @nogc @safe @property inout inout(TypeExpression) isTypeExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(IntegerExpression) isIntegerExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(RealNumberExpression) isRealNumberExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(StringExpression) isStringExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(IdentifierExpression) isIdentifierExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(AnyExpression) isAnyExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(FalseExpression) isFalseExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(TrueExpression) isTrueExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(NullExpression) isNullExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(ThisExpression) isThisExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(SuperExpression) isSuperExpression() { return this; }
	
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
	
	override @nogc @safe @property inout inout(DollarExpression) isDollarExpression() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Expression accept(ExpressionVisitor v) {
		return v.visit(this);
	}
}