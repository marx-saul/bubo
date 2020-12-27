module visitor.statement;

import ast.statement;

abstract class StatementVisitor {
	Statement visit(Statement x)					{ assert(0); }
	Statement visit(ErrorStatement x)				{ assert(0); }
	Statement visit(CompoundStatement x)			{ assert(0); }
	Statement visit(BreakStatement x)				{ assert(0); }
	Statement visit(ContinueStatement x)			{ assert(0); }
	Statement visit(DoWhileStatement x)				{ assert(0); }
	Statement visit(ExpressionStatement x)			{ assert(0); }
	Statement visit(ForStatement x)					{ assert(0); }
	//Statement visit(ForeachStatement x)		{ assert(0); }
	Statement visit(GotoStatement x)				{ assert(0); }
	Statement visit(IfElseStatement x)				{ assert(0); }
	Statement visit(ReturnStatement x)				{ assert(0); }
	Statement visit(ScopeStatement x)				{ assert(0); }
	Statement visit(WhileStatement x)				{ assert(0); }
}

abstract class GeneralStatementVisitor : StatementVisitor {
	alias visit = StatementVisitor.visit;
	override Statement visit(ErrorStatement x)					{ return visit(cast(Statement)x); }
	override Statement visit(CompoundStatement x)				{ return visit(cast(Statement)x); }
	override Statement visit(BreakStatement x)					{ return visit(cast(Statement)x); }
	override Statement visit(ContinueStatement x)				{ return visit(cast(Statement)x); }
	override Statement visit(DoWhileStatement x)				{ return visit(cast(Statement)x); }
	override Statement visit(ExpressionStatement x)				{ return visit(cast(Statement)x); }
	override Statement visit(ForStatement x)					{ return visit(cast(Statement)x); }
	//override Statement visit(ForeachStatement x)							{ return visit(cast(Statement)x); }
	override Statement visit(GotoStatement x)					{ return visit(cast(Statement)x); }
	override Statement visit(IfElseStatement x)					{ return visit(cast(Statement)x); }
	override Statement visit(ReturnStatement x)					{ return visit(cast(Statement)x); }
	override Statement visit(ScopeStatement x)					{ return visit(cast(Statement)x); }
	override Statement visit(WhileStatement x)					{ return visit(cast(Statement)x); }
}