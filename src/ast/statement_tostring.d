module ast.statement_tostring;

import ast.statement;
import decoration;
import identifier;
import token;
import visitor.general;

string recoverCode(Statement stmt, size_t depth = 0, bool all_paren = false) {
	scope stsv = new StatementToStringVisitor(depth, all_paren);
	if (stmt) stmt.accept(stsv);
	return stsv.result;
}

class StatementToStringVisitor : GeneralVisitor {
	string result;
	alias visit = GeneralVisitor.visit;
	
	size_t depth;
	bool all_paren;
	this (size_t depth, bool all_paren) {
		this.depth = depth;
		this.all_paren = all_paren;
	}
	
	void indent() {
		foreach (_; 0 .. depth) result ~= "    ";
	}
	override void visit(ErrorStatement stmt) {
		indent();
		result ~= "__error_statement__";
	}
	override void visit(CompoundStatement cs) {
		++depth;
		foreach (stmt; cs.stmts) {
			if (stmt) stmt.accept(this);
			result ~= "\n";
		}
		if (cs.stmts.length > 0) result.length -= 1;
		--depth;
	}
	override void visit(BreakStatement bs) {
		indent();
		result ~= "break";
		if (bs.label != Identifier.init) result ~= " " ~ bs.label.name;
	}
	override void visit(ContinueStatement bs) {
		indent();
		result ~= "continue";
		if (bs.label != Identifier.init) result ~= " " ~ bs.label.name;
	}
	override void visit(DoWhileStatement dws) {
		import ast.expression_tostring : recoverCode;
		
		indent();
		result ~= "do\n";
		if (dws._body) dws._body.accept(this);
		result ~= "while ";
		result ~= recoverCode(dws.cond, all_paren);
	}
	override void visit(ExpressionStatement exs) {
		import ast.expression_tostring : recoverCode;
		
		indent();
		result ~= recoverCode(exs.expr, all_paren);
	}
	override void visit(ForStatement fs) {
		import ast.expression_tostring : recoverCode;
		
		indent();
		result ~= "for ";
		if (fs.is_let) result ~= "let ";
		result ~= recoverCode(fs._init, all_paren);
		result ~= ";";
		result ~= recoverCode(fs.cond, all_paren);
		result ~= ";";
		result ~= recoverCode(fs.exec, all_paren);
		result ~= "\n";
		if (fs._body) fs._body.accept(this);
	}
	override void visit(GotoStatement gs) {
		indent();
		result ~= "goto " ~ gs.label.name;
	}
	override void visit(IfElseStatement ies) {
		import ast.expression_tostring : recoverCode;
		
		indent();
		result ~= "if ";
		if (ies.is_let) result ~= "let ";
		result ~= recoverCode(ies.cond, all_paren);
		result ~= "\n";
		if (ies.if_stmt) ies.if_stmt.accept(this);
		if (ies.else_stmt) {
			result ~= "else\n";
			ies.else_stmt.accept(this);
		}
	}
	override void visit(ReturnStatement rs) {
		import ast.expression_tostring : recoverCode;
		
		indent();
		result ~= "return";
		if (rs.expr) {
			result ~= " " ~ recoverCode(rs.expr);
		}
	}
	override void visit(ScopeStatement ss) {
		indent();
		result ~= "scope";
		with (SSKind)
		final switch (ss.kind) {
		case block:
			result ~= "\n";
			break;
			
		case exit:
			result ~= " exit\n";
			break;
			
		case failure:
			result ~= " failure\n";
			break;
			
		case return_:
			result ~= " return\n";
			break;
			
		case success:
			result ~= " success\n";
			break;
		}
		if (ss._body) ss._body.accept(this);
	}
	override void visit(WhileStatement ws) {
		import ast.expression_tostring : recoverCode;
		
		indent();
		result ~= "while ";
		if (ws.cond) result ~= recoverCode(ws.cond, all_paren);
		result ~= "\n";
		if (ws._body) ws._body.accept(this);
	}
}