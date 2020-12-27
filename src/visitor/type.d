module visitor.type;

import ast.type;

abstract class TypeVisitor {
	Type visit(Type x)						{ assert(0); }
	Type visit(ErrorType x)					{ assert(0); }
	Type visit(BasicType x)					{ assert(0); }
	Type visit(NextType x)					{ assert(0); }
	Type visit(DotIdentifierType x)			{ assert(0); }
	//Type visit(DotInstanceType x)			{ assert(0); }
	Type visit(ArrayType x)					{ assert(0); }
	Type visit(AssocArrayType x)			{ assert(0); }
	Type visit(PointerType x)				{ assert(0); }
	Type visit(LazyType x)					{ assert(0); }
	Type visit(IndexType x)					{ assert(0); }
	Type visit(SliceType x)					{ assert(0); }
	Type visit(TupleType x)					{ assert(0); }
	Type visit(RecordType x)				{ assert(0); }
	Type visit(FunctionType x)				{ assert(0); }
	Type visit(NullType x)					{ assert(0); }
	Type visit(TypeofType x)				{ assert(0); }
	Type visit(IdentifierType x)			{ assert(0); }
	//Type visit(InstanceType x)				{ assert(0); }
}

abstract class GeneralTypeVisitor : TypeVisitor {
	alias visit = TypeVisitor.visit;
	override Type visit(ErrorType x)				{ return visit(cast(Type)x); }
	override Type visit(BasicType x)				{ return visit(cast(Type)x); }
	override Type visit(NextType x)					{ return visit(cast(Type)x); }
	override Type visit(DotIdentifierType x)		{ return visit(cast(NextType)x); }
	//override Type visit(DotInstanceType x)			{ return visit(cast(NextType)x); }
	override Type visit(ArrayType x)				{ return visit(cast(NextType)x); }
	override Type visit(AssocArrayType x)			{ return visit(cast(NextType)x); }
	override Type visit(PointerType x)				{ return visit(cast(NextType)x); }
	override Type visit(LazyType x)					{ return visit(cast(NextType)x); }
	override Type visit(IndexType x)				{ return visit(cast(NextType)x); }
	override Type visit(SliceType x)				{ return visit(cast(NextType)x); }
	override Type visit(TupleType x)				{ return visit(cast(Type)x); }
	override Type visit(RecordType x)				{ return visit(cast(Type)x); }
	override Type visit(FunctionType x)				{ return visit(cast(Type)x); }
	override Type visit(NullType x)					{ return visit(cast(Type)x); }
	override Type visit(TypeofType x)				{ return visit(cast(Type)x); }
	override Type visit(IdentifierType x)			{ return visit(cast(Type)x); }
	//override Type visit(InstanceType x)				{ return visit(cast(Type)x); }
}