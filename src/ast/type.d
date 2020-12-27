module ast.type;

import ast.astnode;
import ast.expression;
import identifier;
import token;
import visitor.type;
import visitor.visitor;

/// the type class
abstract class Type : ASTNode {
	bool paren;
	
	@nogc @safe @property inout {
		inout(ErrorType) isErrorType() { return null; }
		inout(NextType) isNextType() { return null; }
		inout(DotIdentifierType) isDotIdentifierType() { return null; }
		//inout(DotInstanceType) isDotInstanceType() { return null; }
		inout(ArrayType) isArrayType() { return null; }
		inout(AssocArrayType) isAssocArrayType() { return null; }
		inout(PointerType) isPointerType() { return null; }
		inout(LazyType) isLazyType() { return null; }
		inout(IndexType) isIndexType() { return null; }
		inout(SliceType) isSliceType() { return null; }
		inout(TupleType) isTupleType() { return null; }
		inout(RecordType) isRecordType() { return null; }
		inout(FunctionType) isFunctionType() { return null; }
		inout(NullType) isNullType() { return null; }
		inout(TypeofType) isTypeofType() { return null; }
		inout(BasicType) isBasicType() { return null; }
		inout(IdentifierType) isIdentifierType() { return null; }
		//inout(InstanceType) isInstanceType() { return null; }
		//inout(Type) isType() { return null; }
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// 
final class ErrorType : Type {
	Location loc;
	
	this(Location loc) {
		this.loc = loc;
	}
	
	override @nogc @safe @property inout inout(ErrorType) isErrorType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// 
abstract class NextType : Type {
	Type next;
	
	this(Type next, bool paren = false) {
		this.next = next;
		this.paren = paren;
	}
	
	override @nogc @safe @property inout inout(NextType) isNextType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// T.id
final class DotIdentifierType : NextType {
	Identifier id;
	
	this(Type next, Identifier id, bool paren = false) {
		super(next, paren);
		this.id = id;
	}
	
	override @nogc @safe @property inout inout(DotIdentifierType) isDotIdentifierType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/+
/// T.id!(...) 
final class DotInstanceType : NextType {
	//TemplateInstance inst;
	
	override @nogc @safe @property inout inout(DotInstanceType) isDotInstanceType() { return this; }
	
	this(Type next, /*TemplateInstance inst,*/ bool paren = false) {
		super(next, paren);
		//this.inst = inst;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}
+/

/// [T]
final class ArrayType : NextType {
	alias elem = next;
	
	override @nogc @safe @property inout inout(ArrayType) isArrayType() { return this; }
	
	this(Type next, bool paren = false) {
		super(next, paren);
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// [T:S]
final class AssocArrayType : NextType {
	alias key = next;
	Type value;
	
	override @nogc @safe @property inout inout(AssocArrayType) isAssocArrayType() { return this; }
	
	this(Type key, Type value, bool paren = false) {
		super(key, paren);
		this.value = value;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// *T
final class PointerType : NextType {
	this(Type next, bool paren = false) {
		super(next, paren);
	}
	
	override @nogc @safe @property inout inout(PointerType) isPointerType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// lazy T
final class LazyType : NextType {
	this(Type next, bool paren = false) {
		super(next, paren);
	}
	
	override @nogc @safe @property inout inout(LazyType) isLazyType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// T[E]
final class IndexType : NextType {
	Expression exp;
	
	this(Type next, Expression exp, bool paren = false) {
		super(next, paren);
		this.exp = exp;
	}
	
	override @nogc @safe @property inout inout(IndexType) isIndexType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// T[E .. E]
final class SliceType : NextType {
	Expression exp1;
	Expression exp2;
	
	this(Type next, Expression exp1, Expression exp2, bool paren = false) {
		super(next, paren);
	}
	
	override @nogc @safe @property inout inout(SliceType) isSliceType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// (T1, T2, ...)
final class TupleType : Type {
	Type[] elems;
	
	this(Type[] elems, bool paren = false) {
		this.elems = elems;
		this.paren = paren;
	}
	
	override @nogc @safe @property inout inout(TupleType) isTupleType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// {id1: T1, id2: T2, ...}
final class RecordType : Type {
	Type[string] record;
	this(Type[string] record, bool paren = false) {
		this.paren = paren;
		this.record = record;
	}
	
	override @nogc @safe @property inout inout(RecordType) isRecordType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// (T1, T2, ...) => S
final class FunctionType : Type {
	Type[] params;
	Type ret;
	
	this(Type[] params, Type ret, bool paren = false) {
		this.params = params;
		this.ret = ret;
		this.paren = paren;
	}
	
	override @nogc @safe @property inout inout(FunctionType) isFunctionType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// type of null
final class NullType : Type {
	this (bool paren = false) {
		this.paren = paren;
	}
	
	override @nogc @safe @property inout inout(NullType) isNullType() { return this; }
		
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// typeof(E)
final class TypeofType : Type {
	Expression exp;
	
	this (Expression exp, bool paren = false) {
		this.exp = exp;
		this.paren = paren;
	}
	
	override @nogc @safe @property inout inout(TypeofType) isTypeofType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

/// void, bool, int8, uint8, int16, uint16, int32, uint32, int64, uint64, real32, real64, 
final class BasicType : Type {
	TokenKind kind;
	
	this(TokenKind kind, bool paren = false) {
		this.kind = kind;
		this.paren = paren;
	}
	
	override @nogc @safe @property inout inout(BasicType) isBasicType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

final class IdentifierType : Type {
	Identifier id;
	bool is_global;
	
	this(Identifier id, bool is_global, bool paren = false) {
		this.id = id;
		this.is_global = is_global;
		this.paren = paren;
	}
	
	override @nogc @safe @property inout inout(IdentifierType) isIdentifierType() { return this; }
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}
/+
final class InstanceType : Type {
	bool is_global;
	TemplateInstance inst;
	
	this(TemplateInstance inst, bool is_global, bool paren = false) {
		this.kind = kind;
		this.is_global = is_global;
		this.paren = paren;
	}
	
	override void accept(Visitor v) {
		v.visit(this);
	}
	override Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}
+/

/*
final class TypedefType : Type {
	//Typedef symbol;
	override void accept(Visitor v) {
		v.visit(this);
	}
	Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}
final class StructType : Type {
	//StructDeclaration symbol;
	override void accept(Visitor v) {
		v.visit(this);
	}
	Type accept(TypeVisitor v) {
		return v.visit(this);
	}
}

*/
