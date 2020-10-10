module ast.astnode;

import visitor.visitor;

/// The root object of all AST nodes
abstract class ASTNode {
	void accept(Visitor) { assert(0); }
}