package wren;

import wren.WrenVM;
import cpp.ConstCharStar;
import cpp.Callable;
import cpp.SizeT;
import cpp.RawPointer;

@:structAccess
@:native('WrenConfiguration')
@:include('linc_wren.h')
extern class WrenConfiguration {
	// TODO: WrenReallocateFn reallocateFn
	// TODO: WrenResolveModuleFn resolveModuleFn
	public var loadModuleFn:Callable<(
		vm:RawWrenVM,
		name:ConstCharStar
	)->WrenLoadModuleResult>;
	public var bindForeignMethodFn:Callable<(
		vm:RawWrenVM,
		module:ConstCharStar,
		className:ConstCharStar,
		isStatic:Bool,
		signature:ConstCharStar
	)->WrenForeignMethodFn>;
	public var bindForeignClassFn:Callable<(
		vm:RawWrenVM,
		module:ConstCharStar,
		className:ConstCharStar
	)->WrenForeignClassMethods>;
	public var writeFn:Callable<(
		vm:RawWrenVM,
		text:ConstCharStar
	)->Void>;
	public var errorFn:Callable<(
		vm:RawWrenVM,
		type:wren.Wren.WrenErrorType,
		module:ConstCharStar,
		line:Int, 
		message:ConstCharStar
	)->Void>;
	public var initialHeapSize : SizeT;
	public var minHeapSize : SizeT;
	public var heapGrowthPercent : Int;
	public var userData: RawPointer<Void>;
	
	@:native('linc::wren::initConfiguration')
	public static function init():WrenConfiguration;
}
