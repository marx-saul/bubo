module visitor.expression;

import ast.expression;

/// visitor class for expression, with return value of type Expression
abstract class ExpressionVisitor {
	Expression visit(Expression) { assert(0); }
	Expression visit(ErrorExpression) { assert(0); }
	Expression visit(UnaryExpression) { assert(0); }
	Expression visit(PlusExpression) { assert(0); }
	Expression visit(MinusExpression) { assert(0); }
	Expression visit(PreIncExpression) { assert(0); }
	Expression visit(PreDecExpression) { assert(0); }
	Expression visit(RefExpression) { assert(0); }
	Expression visit(DerefExpression) { assert(0); }
	Expression visit(NotExpression) { assert(0); }
	Expression visit(ComplementExpression) { assert(0); }
	Expression visit(PostIncExpression) { assert(0); }
	Expression visit(PostDecExpression) { assert(0); }
	Expression visit(CallExpression) { assert(0); }
	Expression visit(IndexExpression) { assert(0); }
	Expression visit(SliceExpression) { assert(0); }
	Expression visit(BinaryExpression) { assert(0); }
	Expression visit(AssignExpression) { assert(0); }
	Expression visit(BinaryAssignExpression) { assert(0); }
	Expression visit(OrAssignExpression) { assert(0); }
	Expression visit(XorAssignExpression) { assert(0); }
	Expression visit(AndAssignExpression) { assert(0); }
	Expression visit(LShiftAssignExpression) { assert(0); }
	Expression visit(RShiftAssignExpression) { assert(0); }
	Expression visit(LogicalShiftAssignExpression) { assert(0); }
	Expression visit(AddAssignExpression) { assert(0); }
	Expression visit(SubAssignExpression) { assert(0); }
	Expression visit(CatAssignExpression) { assert(0); }
	Expression visit(MulAssignExpression) { assert(0); }
	Expression visit(DivAssignExpression) { assert(0); }
	Expression visit(ModAssignExpression) { assert(0); }
	Expression visit(PowAssignExpression) { assert(0); }
	Expression visit(PipelineExpression) { assert(0); }
	Expression visit(OrOrExpression) { assert(0); }
	Expression visit(XorXorExpression) { assert(0); }
	Expression visit(AndAndExpression) { assert(0); }
	Expression visit(OrExpression) { assert(0); }
	Expression visit(XorExpression) { assert(0); }
	Expression visit(AndExpression) { assert(0); }
	Expression visit(IdentityExpression) { assert(0); }
	Expression visit(InExpression) { assert(0); }
	Expression visit(LsExpression) { assert(0); }
	Expression visit(LeqExpression) { assert(0); }
	Expression visit(GtExpression) { assert(0); }
	Expression visit(GeqExpression) { assert(0); }
	Expression visit(EqExpression) { assert(0); }
	Expression visit(LShiftExpression) { assert(0); }
	Expression visit(RShiftExpression) { assert(0); }
	Expression visit(LogicalShiftExpression) { assert(0); }
	Expression visit(AddExpression) { assert(0); }
	Expression visit(SubExpression) { assert(0); }
	Expression visit(CatExpression) { assert(0); }
	Expression visit(MulExpression) { assert(0); }
	Expression visit(DivExpression) { assert(0); }
	Expression visit(ModExpression) { assert(0); }
	Expression visit(ArrowExpression) { assert(0); }
	Expression visit(PowExpression) { assert(0); }
	Expression visit(DotExpression) { assert(0); }
	Expression visit(WhenElseExpression) { assert(0); }
	Expression visit(TupleExpression) { assert(0); }
	Expression visit(ArrayExpression) { assert(0); }
	Expression visit(AssocArrayExpression) { assert(0); }
	Expression visit(RecordExpression) { assert(0); }
	Expression visit(TypeExpression) { assert(0); }
	Expression visit(IntegerExpression) { assert(0); }
	Expression visit(RealNumberExpression) { assert(0); }
	Expression visit(StringExpression) { assert(0); }
	Expression visit(IdentifierExpression) { assert(0); }
	Expression visit(AnyExpression) { assert(0); }
	Expression visit(FalseExpression) { assert(0); }
	Expression visit(TrueExpression) { assert(0); }
	Expression visit(NullExpression) { assert(0); }
	Expression visit(ThisExpression) { assert(0); }
	Expression visit(SuperExpression) { assert(0); }
	Expression visit(DollarExpression) { assert(0); }
}

/// general visitor class for expression, with return value of type Expression
abstract class GeneralExpressionVisitor : ExpressionVisitor {
	alias visit = ExpressionVisitor.visit;
	override Expression visit(ErrorExpression x)					{ return visit(cast(UnaryExpression)x); }
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
	override Expression visit(BinaryAssignExpression x)				{ return visit(cast(Expression)x); }
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
	override Expression visit(ArrowExpression x)					{ return visit(cast(BinaryExpression)x); }
	override Expression visit(PowExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(DotExpression x)						{ return visit(cast(BinaryExpression)x); }
	override Expression visit(WhenElseExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(TupleExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(ArrayExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(AssocArrayExpression x)				{ return visit(cast(Expression)x); }
	override Expression visit(RecordExpression x)					{ return visit(cast(Expression)x); }
	override Expression visit(TypeExpression x)						{ return visit(cast(Expression)x); }
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