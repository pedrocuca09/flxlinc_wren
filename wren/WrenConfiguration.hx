package wren;

import wren.WrenVM;

@:structAccess
@:native('WrenConfiguration')
@:include('linc_wren.h')
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
	)->WrenForeignClassMethods>;
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
