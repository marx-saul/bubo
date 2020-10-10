module visitor.general;

import ast;
import visitor.visitor;

class GeneralVisitor : Visitor {
	override void visit(ASTNode x) 								{ visit(cast()x); }
	
	// ast.expression
	override void visit(Expression x)							{ visit(cast(ASTNode)x); }
	override void visit(UnaryExpression x)						{ visit(cast(Expression)x); }
	override void visit(PlusExpression x)						{ visit(cast(UnaryExpression)x); }
	override void visit(MinusExpression x)						{ visit(cast(UnaryExpression)x); }
	override void visit(PreIncExpression x)						{ visit(cast(UnaryExpression)x); }
	override void visit(PreDecExpression x)						{ visit(cast(UnaryExpression)x); }
	override void visit(RefExpression x)						{ visit(cast(UnaryExpression)x); }
	override void visit(DerefExpression x)						{ visit(cast(UnaryExpression)x); }
	override void visit(NotExpression x)						{ visit(cast(UnaryExpression)x); }
	override void visit(ComplementExpression x)					{ visit(cast(UnaryExpression)x); }
	override void visit(PostIncExpression x)					{ visit(cast(UnaryExpression)x); }
	override void visit(PostDecExpression x)					{ visit(cast(UnaryExpression)x); }
	override void visit(CallExpression x)						{ visit(cast(Expression)x); }
	override void visit(IndexExpression x)						{ visit(cast(Expression)x); }
	override void visit(SliceExpression x)						{ visit(cast(Expression)x); }
	override void visit(BinaryExpression x)						{ visit(cast(Expression)x); }
	override void visit(AssignExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(BinaryAssignExpression x)				{ visit(cast(BinaryExpression)x); }
	override void visit(OrAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(XorAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(AndAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(LShiftAssignExpression x)				{ visit(cast(BinaryAssignExpression)x); }
	override void visit(RShiftAssignExpression x)				{ visit(cast(BinaryAssignExpression)x); }
	override void visit(LogicalShiftAssignExpression x)			{ visit(cast(BinaryAssignExpression)x); }
	override void visit(AddAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(SubAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(CatAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(MulAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(DivAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(ModAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(PowAssignExpression x)					{ visit(cast(BinaryAssignExpression)x); }
	override void visit(PipelineExpression x)					{ visit(cast(BinaryExpression)x); }
	override void visit(OrOrExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(XorXorExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(AndAndExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(OrExpression x)							{ visit(cast(BinaryExpression)x); }
	override void visit(XorExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(AndExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(IdentityExpression x)					{ visit(cast(BinaryExpression)x); }
	override void visit(InExpression x)							{ visit(cast(BinaryExpression)x); }
	override void visit(LsExpression x)							{ visit(cast(BinaryExpression)x); }
	override void visit(LeqExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(GtExpression x)							{ visit(cast(BinaryExpression)x); }
	override void visit(GeqExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(EqExpression x)							{ visit(cast(BinaryExpression)x); }
	override void visit(LShiftExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(RShiftExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(LogicalShiftExpression x)				{ visit(cast(BinaryExpression)x); }
	override void visit(AddExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(SubExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(CatExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(MulExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(DivExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(ModExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(PowExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(DotExpression x)						{ visit(cast(BinaryExpression)x); }
	override void visit(WhenElseExpression x)					{ visit(cast(Expression)x); }
	override void visit(TupleExpression x)						{ visit(cast(Expression)x); }
	override void visit(ArrayExpression x)						{ visit(cast(Expression)x); }
	override void visit(AssocArrayExpression x)					{ visit(cast(Expression)x); }
	override void visit(IntegerExpression x)					{ visit(cast(Expression)x); }
	override void visit(RealNumberExpression x)					{ visit(cast(Expression)x); }
	override void visit(StringExpression x)						{ visit(cast(Expression)x); }
	override void visit(IdentifierExpression x)					{ visit(cast(Expression)x); }
	override void visit(AnyExpression x)						{ visit(cast(Expression)x); }
	override void visit(FalseExpression x)						{ visit(cast(Expression)x); }
	override void visit(TrueExpression x)						{ visit(cast(Expression)x); }
	override void visit(NullExpression x)						{ visit(cast(Expression)x); }
	override void visit(ThisExpression x)						{ visit(cast(Expression)x); }
	override void visit(SuperExpression x)						{ visit(cast(Expression)x); }
	override void visit(DollarExpression x)						{ visit(cast(Expression)x); }
}