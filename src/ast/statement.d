module ast.statement;

import ast.astnode;
import ast.expression;
import ast.type;
import identifier;
import token;
import visitor.statement;
import visitor.visitor;

abstract class Statement: ASTNode {
	Location loc;
	this(Location loc) {
		this.loc = loc;
	}
	
	@nogc @safe @property inout {
		inout(ErrorStatement) isErrorStatement() { return null; }
		inout(CompoundStatement) isCompoundStatement() { return null; }
		inout(BreakStatement) isBreakStatement() { return null; }
		inout(ContinueStatement) isContinueStatement() { return null; }
		//inout(DeclarationStatement) isDeclarationStatement() { return null; }
		inout(DoWhileStatement) isDoWhileStatement() { return null; }
		inout(ExpressionStatement) isExpressionStatement() { return null; }
		inout(ForStatement) isForStatement() { return null; }
		inout(GotoStatement) isGotoStatement() { return null; }
		inout(IfElseStatement) isIfElseStatement() { return null; }
		inout(ReturnStatement) isReturnStatement() { return null; }
		inout(ScopeStatement) isScopeStatement() { return null; }
		inout(WhileStatement) isWhileStatement() { return null; }
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class ErrorStatement: Statement {
	this(Location loc = Location.init) {
		super(loc);
	}
	
	override @nogc @safe @property inout inout(ErrorStatement) isErrorStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class CompoundStatement : Statement {
	Statement[] stmts;
	this(Location loc, Statement[] stmts) {
		super(loc);
		this.stmts = stmts;
	}
	
	override @nogc @safe @property inout inout(CompoundStatement) isCompoundStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class BreakStatement: Statement {
	Identifier label;
	this(Location loc, Identifier label = Identifier.init) {
		super(loc);
		this.label = label;
	}
	
	override @nogc @safe @property inout inout(BreakStatement) isBreakStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class ContinueStatement: Statement {
	Identifier label;
	this(Location loc, Identifier label = Identifier.init) {
		super(loc);
		this.label = label;
	}
	
	override @nogc @safe @property inout inout(ContinueStatement) isContinueStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

//final class DeclarationStatement: Statement {}

final class DoWhileStatement: Statement {
	CompoundStatement _body;
	Expression cond;
	this(Location loc, CompoundStatement _body, Expression cond) {
		super(loc);
		this._body = _body;
		this.cond = cond;
	}
	
	override @nogc @safe @property inout inout(DoWhileStatement) isDoWhileStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class ExpressionStatement: Statement {
	Expression expr;
	this(Location loc, Expression expr) {
		super(loc);
		this.expr = expr;
	}
	
	override @nogc @safe @property inout inout(ExpressionStatement) isExpressionStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class ForStatement: Statement {
	bool is_let;	// declare new variable
	Expression _init;
	Expression cond;
	Expression exec;
	CompoundStatement _body;
	this(Location loc, bool is_let, Expression _init, Expression cond, Expression exec, CompoundStatement _body) {
		super(loc);
		this.is_let = is_let;
		this._init = _init;
		this.cond = cond;
		this.exec = exec;
		this._body = _body;
	}
	
	override @nogc @safe @property inout inout(ForStatement) isForStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}
/+
final class ForeachStatement: Statement {
	Identifier[] ids;
}
+/

final class GotoStatement: Statement {
	Identifier label;
	this(Location loc, Identifier label) {
		super(loc);
		this.label = label;
	}
	
	override @nogc @safe @property inout inout(GotoStatement) isGotoStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class IfElseStatement: Statement {
	bool is_let;
	Expression cond;
	CompoundStatement if_stmt;
	CompoundStatement else_stmt;
	this(Location loc, bool is_let, Expression cond, CompoundStatement if_stmt, CompoundStatement else_stmt) {
		super(loc);
		this.is_let = is_let;
		this.cond = cond;
		this.if_stmt = if_stmt;
		this.else_stmt = else_stmt;
	}
	
	override @nogc @safe @property inout inout(IfElseStatement) isIfElseStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class ReturnStatement: Statement {
	Expression expr;
	this(Location loc, Expression expr) {
		super(loc);
		this.expr = expr;
	}
	
	override @nogc @safe @property inout inout(ReturnStatement) isReturnStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

/// the Kind of the Scope Statement
enum SSKind {
	block,		/// scope
	exit,		/// scope exit
	failure,	/// scope failure
	return_,	/// scope return
	success,	/// scope success
}

final class ScopeStatement: Statement {
	SSKind kind;
	CompoundStatement _body;
	this(Location loc, SSKind kind, CompoundStatement _body) {
		super(loc);
		this.kind = kind;
		this._body = _body;
	}
	
	override @nogc @safe @property inout inout(ScopeStatement) isScopeStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}

final class WhileStatement: Statement {
	Expression cond;
	CompoundStatement _body;
	this(Location loc, Expression cond, CompoundStatement _body) {
		super(loc);
		this.cond = cond;
		this._body = _body;
	}
	
	override @nogc @safe @property inout inout(WhileStatement) isWhileStatement() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Statement accept(StatementVisitor v) {
		return v.visit(this);
	}
}