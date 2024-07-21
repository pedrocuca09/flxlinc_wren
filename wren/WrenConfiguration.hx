package wren;

import wren.WrenVM;

@:structAccess
@:native('WrenConfiguration')
extern class WrenConfiguration {
	// TODO: WrenReallocateFn reallocateFn
	// TODO: WrenResolveModuleFn resolveModuleFn
	// TODO: WrenLoadModuleFn loadModuleFn
	public var bindForeignMethodFn:cpp.Callable<(
		vm:RawWrenVM,
		module:cpp.ConstCharStar,
		className:cpp.ConstCharStar,
		isStatic:Bool,
		signature:cpp.ConstCharStar
	)->WrenForeignMethodFn>;
	public var bindForeignClassFn:cpp.Callable<(
		vm:RawWrenVM,
		module:cpp.ConstCharStar,
		className:cpp.ConstCharStar
	)->Void>;
	public var writeFn:cpp.Callable<(
		vm:RawWrenVM,
		text:cpp.ConstCharStar
	)->Void>;
	public var errorFn:cpp.Callable<(
		vm:RawWrenVM,
		type:wren.Wren.WrenErrorType,
		module:cpp.ConstCharStar,
		line:Int, 
		message:cpp.ConstCharStar
	)->Void>;
	public var initialHeapSize : cpp.SizeT;
	public var minHeapSize : cpp.SizeT;
	public var heapGrowthPercent : Int;
	public var userData: cpp.RawPointer<Void>;
	
	@:native('linc::wren::initConfiguration')
	public static function init():WrenConfiguration;
}

@:native('WrenForeignMethodFn')
extern class WrenForeignMethodFnNative {}
abstract WrenForeignMethodFn(WrenForeignMethodFnNative) {
	@:from
	static inline function fromCallable(f:cpp.Callable<(vm:RawWrenVM)->Void>) {
		return cast f;
	}
}