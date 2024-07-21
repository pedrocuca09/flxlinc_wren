package wren;

// @:native('WrenWriteFn')
// extern class WrenWriteFn {}


@:native('WrenVM')
// @:headerInclude('linc_wren.h')
@:include('linc_wren.h')
extern class RawWrenVM {}

@:structAccess
@:native('WrenConfiguration')
extern class WrenConfiguration {
	// TODO: WrenReallocateFn reallocateFn
	// TODO: WrenResolveModuleFn resolveModuleFn
	// TODO: WrenLoadModuleFn loadModuleFn
	public var bindForeignMethodFn:cpp.Callable<(
		vm:cpp.RawPointer<RawWrenVM>,
		module:cpp.ConstCharStar,
		className:cpp.ConstCharStar,
		isStatic:Bool,
		signature:cpp.ConstCharStar
	)->WrenForeignMethodFn>;
	public var bindForeignClassFn:cpp.Callable<(
		vm:cpp.RawPointer<RawWrenVM>,
		module:cpp.ConstCharStar,
		className:cpp.ConstCharStar
	)->Void>;
	public var writeFn:cpp.Callable<(
		vm:cpp.RawPointer<RawWrenVM>,
		text:cpp.ConstCharStar
	)->Void>;
	public var errorFn:cpp.Callable<(
		vm:cpp.RawPointer<RawWrenVM>,
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
	static inline function fromCallable(f:cpp.Callable<(vm:cpp.RawPointer<RawWrenVM>)->Void>) {
		return cast f;
	}
}