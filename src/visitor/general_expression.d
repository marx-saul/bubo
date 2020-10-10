module visitor.general_expression;

import ast.expression;
import visitor.expression;

/// general visitor class for expression, with return value of type Expression
abstract class GeneralExpressionVisitor : ExpressionVisitor {
	alias visit = ExpressionVisitor.visit;
	override Expression visit(UnaryExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(PlusExpression x)						{ return visit(cast(UnaryExpression)x); }
	override Expression visit(MinusExpression x)					{ return visit(cast(UnaryExpression)x); }
	override Expression visit(PreIncExpression x)					{ return visit(cast(UnaryExpression)x); }
	override Expression visit(PreDecExpression x)					{ return visit(cast(UnaryExpression)x); }
	override Expression visit(RefExpression x)						{ return visit(cast(UnaryExpression)x); }
	override Expression visit(DerefExpression x)					{ return visit(cast(UnaryExpression)x); }
	override Expression visit(NotExpression x)						{ return visit(cast(UnaryExpression)x); }
	override Expression visit(ComplementExpression x)				{ return visit(cast(UnaryExpression)x); }
	override Expression visit(PostIncExpression x)					{ return visit(cast(UnaryExpression)x); }
	override Expression visit(PostDecExpression x)					{ return visit(cast(UnaryExpression)x); }
	override Expression visit(CallExpression x)						{ return visit(cast(Expression)x); }
	override Expression visit(IndexExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(SliceExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(BinaryExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(AssignExpression x)					{ return visit(cast(BinaryExpression)x); }
	override Expression visit(BinaryAssignExpression x)				{ return visit(cast(BinaryExpression)x); }
	override Expression visit(OrAssignExpression x)					{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(XorAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(AndAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(LShiftAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(RShiftAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(LogicalShiftAssignExpression x)		{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(AddAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(SubAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(CatAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(MulAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(DivAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(ModAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(PowAssignExpression x)				{ return visit(cast(BinaryAssignExpression)x); }
	override Expression visit(PipelineExpression x)					{ return visit(cast(BinaryExpression)x); }
	override Expression visit(OrOrExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(XorXorExpression x)					{ return visit(cast(BinaryExpression)x); }
	override Expression visit(AndAndExpression x)					{ return visit(cast(BinaryExpression)x); }
	override Expression visit(OrExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(XorExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(AndExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(IdentityExpression x)					{ return visit(cast(BinaryExpression)x); }
	override Expression visit(InExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(LsExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(LeqExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(GtExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(GeqExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(EqExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(LShiftExpression x)					{ return visit(cast(BinaryExpression)x); }
	override Expression visit(RShiftExpression x)					{ return visit(cast(BinaryExpression)x); }
	override Expression visit(LogicalShiftExpression x)				{ return visit(cast(BinaryExpression)x); }
	override Expression visit(AddExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(SubExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(CatExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(MulExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(DivExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(ModExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(PowExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(DotExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(WhenElseExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(TupleExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(ArrayExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(AssocArrayExpression x)				{ return visit(cast(Expression)x); }
	override Expression visit(IntegerExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(RealNumberExpression x)				{ return visit(cast(Expression)x); }
	override Expression visit(StringExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(IdentifierExpression x)				{ return visit(cast(Expression)x); }
	override Expression visit(AnyExpression x)						{ return visit(cast(Expression)x); }
	override Expression visit(FalseExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(TrueExpression x)						{ return visit(cast(Expression)x); }
	override Expression visit(NullExpression x)						{ return visit(cast(Expression)x); }
	override Expression visit(ThisExpression x)						{ return visit(cast(Expression)x); }
	override Expression visit(SuperExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(DollarExpression x)					{ return visit(cast(Expression)x); }
}