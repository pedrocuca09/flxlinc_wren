package wren;

import wren.WrenForeignMethodFn;
import wren.WrenForeignClassMethods;
// import wren.Wren;
import cpp.Star;
import cpp.Reference;
import cpp.Callable;
import cpp.Pointer;

/** The real value type in C **/
private typedef Native = wren.native.WrenVM;
extern abstract WrenVM(Pointer<Native>) from Pointer<Native> to Pointer<Native> {
	@:from
	static inline function fromStar(v:Star<Native>):WrenVM {
		return Pointer.fromStar(v);
	}
	
	@:to
	inline function toStar():Star<Native> {
		return cast this.raw;
	}

	@:native('linc::hxwren::makeVM')
	private static function _make(config:{
		writeFn:(vm:WrenVM, text:String)->Void,
		errorFn:(vm:WrenVM, type:WrenErrorType, module:String, line:Int, message:String)->Void,
		loadModuleFn:(vm:WrenVM, module:String)->String,
		bindForeignMethodFn:(vm:WrenVM, module:String, className:String, isStatic:Bool, signature:String)->WrenForeignMethodFn,
		bindForeignClassFn:(vm:WrenVM, module:String, className:String)->WrenForeignClassMethods,
	}):Star<Native>;
	
	@:native('linc::hxwren::destroyVM')
	static function destroyVM(vm:WrenVM):Void;
	
	static inline function make(config):WrenVM {
		return _make(config);
	}
}
