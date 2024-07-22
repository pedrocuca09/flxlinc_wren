package wren;

import wren.WrenForeignMethodFn;
import wren.WrenForeignClassMethods;
import wren.Wren;
import cpp.RawPointer;
import cpp.Reference;
import cpp.Callable;

/** Reference form, mostly used for holding the reference in Haxe code **/
@:native('::cpp::Reference<WrenVM>')
@:include('linc_wren.h')
extern class WrenVM {
	@:native('linc::hxwren::makeVM')
	static function makeVM(config:{
		writeFn:(vm:WrenVM, text:String)->Void,
		errorFn:(vm:WrenVM, type:WrenErrorType, module:String, line:Int, message:String)->Void,
		loadModuleFn:(vm:WrenVM, module:String)->String,
		bindForeignMethodFn:(vm:WrenVM, module:String, className:String, isStatic:Bool, signature:String)->Callable<HaxeWrenForeignMethodFn>,
		bindForeignClassFn:(vm:WrenVM, module:String, className:String) -> WrenForeignClassMethodsObject,
		// {allocate: Callable<HaxeWrenForeignMethodFn>, finalize: Callable<HaxeWrenFinalizerFn>},
	}):WrenVM;
	
	@:native('linc::hxwren::destroyVM')
	static function destroyVM(vm:WrenVM):Void;
	
	static inline function make(config):WrenVMObject {
		return makeVM(config);
	}
}

/** The real value type in C **/
@:structAccess
@:native('WrenVM')
@:include('linc_wren.h')
extern class NativeWrenVM {}

/** Raw pointer form, mainly used for callback argument **/
abstract RawWrenVM(RawPointer<NativeWrenVM>) from RawPointer<NativeWrenVM> to RawPointer<NativeWrenVM> {
	@:to
	inline function toReference():WrenVM {
		return cast (cast this : Reference<NativeWrenVM>);
	}
}


class WrenVMObjectBase {
	public final vm:WrenVM;
	
	public function new(vm:WrenVM) {
		this.vm = vm;
		cpp.vm.Gc.setFinalizer(this, Callable.fromStaticFunction(finalize));
	}
	
	static function finalize(vm:WrenVMObjectBase) {
		WrenVM.destroyVM(vm.vm);
	}
}

abstract WrenVMObject(WrenVMObjectBase) from WrenVMObjectBase to WrenVMObjectBase {
	@:from
	static inline function fromNative(v:WrenVM):WrenVMObject {
		return new WrenVMObjectBase(v);
	}
	@:to
	inline function toNative():WrenVM {
		return this.vm;
	}
}