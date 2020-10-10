module visitor.expression;

import ast.expression;

/// visitor class for expression, with return value of type Expression
abstract class ExpressionVisitor {
	Expression visit(Expression) { assert(0); }
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
	Expression visit(PowExpression) { assert(0); }
	Expression visit(DotExpression) { assert(0); }
	Expression visit(WhenElseExpression) { assert(0); }
	Expression visit(TupleExpression) { assert(0); }
	Expression visit(ArrayExpression) { assert(0); }
	Expression visit(AssocArrayExpression) { assert(0); }
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