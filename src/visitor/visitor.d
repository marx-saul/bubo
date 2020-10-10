/**
 * visitor/visitor.d
 * AST Visitor class.
 */module visitor.visitor;

import ast;

abstract class Visitor {
	void visit(ASTNode x) { assert(0); }
	
	// ast.expression
	void visit(Expression) { assert(0); }
	void visit(UnaryExpression) { assert(0); }
	void visit(PlusExpression) { assert(0); }
	void visit(MinusExpression) { assert(0); }
	void visit(PreIncExpression) { assert(0); }
	void visit(PreDecExpression) { assert(0); }
	void visit(RefExpression) { assert(0); }
	void visit(DerefExpression) { assert(0); }
	void visit(NotExpression) { assert(0); }
	void visit(ComplementExpression) { assert(0); }
	void visit(PostIncExpression) { assert(0); }
	void visit(PostDecExpression) { assert(0); }
	void visit(CallExpression) { assert(0); }
	void visit(IndexExpression) { assert(0); }
	void visit(SliceExpression) { assert(0); }
	void visit(BinaryExpression) { assert(0); }
	void visit(AssignExpression) { assert(0); }
	void visit(BinaryAssignExpression) { assert(0); }
	void visit(OrAssignExpression) { assert(0); }
	void visit(XorAssignExpression) { assert(0); }
	void visit(AndAssignExpression) { assert(0); }
	void visit(LShiftAssignExpression) { assert(0); }
	void visit(RShiftAssignExpression) { assert(0); }
	void visit(LogicalShiftAssignExpression) { assert(0); }
	void visit(AddAssignExpression) { assert(0); }
	void visit(SubAssignExpression) { assert(0); }
	void visit(CatAssignExpression) { assert(0); }
	void visit(MulAssignExpression) { assert(0); }
	void visit(DivAssignExpression) { assert(0); }
	void visit(ModAssignExpression) { assert(0); }
	void visit(PowAssignExpression) { assert(0); }
	void visit(PipelineExpression) { assert(0); }
	void visit(OrOrExpression) { assert(0); }
	void visit(XorXorExpression) { assert(0); }
	void visit(AndAndExpression) { assert(0); }
	void visit(OrExpression) { assert(0); }
	void visit(XorExpression) { assert(0); }
	void visit(AndExpression) { assert(0); }
	void visit(IdentityExpression) { assert(0); }
	void visit(InExpression) { assert(0); }
	void visit(LsExpression) { assert(0); }
	void visit(LeqExpression) { assert(0); }
	void visit(GtExpression) { assert(0); }
	void visit(GeqExpression) { assert(0); }
	void visit(EqExpression) { assert(0); }
	void visit(LShiftExpression) { assert(0); }
	void visit(RShiftExpression) { assert(0); }
	void visit(LogicalShiftExpression) { assert(0); }
	void visit(AddExpression) { assert(0); }
	void visit(SubExpression) { assert(0); }
	void visit(CatExpression) { assert(0); }
	void visit(MulExpression) { assert(0); }
	void visit(DivExpression) { assert(0); }
	void visit(ModExpression) { assert(0); }
	void visit(PowExpression) { assert(0); }
	void visit(DotExpression) { assert(0); }
	void visit(WhenElseExpression) { assert(0); }
	void visit(TupleExpression) { assert(0); }
	void visit(ArrayExpression) { assert(0); }
	void visit(AssocArrayExpression) { assert(0); }
	void visit(IntegerExpression) { assert(0); }
	void visit(RealNumberExpression) { assert(0); }
	void visit(StringExpression) { assert(0); }
	void visit(IdentifierExpression) { assert(0); }
	void visit(AnyExpression) { assert(0); }
	void visit(FalseExpression) { assert(0); }
	void visit(TrueExpression) { assert(0); }
	void visit(NullExpression) { assert(0); }
	void visit(ThisExpression) { assert(0); }
	void visit(SuperExpression) { assert(0); }
	void visit(DollarExpression) { assert(0); }
}