package wren;

import wren.WrenVM;
import cpp.Callable;
import cpp.ConstCharStar;

@:native('WrenLoadModuleCompleteFn')
@:include('linc_wren.h')
extern class NativeWrenLoadModuleCompleteFn {}

typedef HaxeWrenLoadModuleCompleteFn = (vm:RawWrenVM, name:ConstCharStar, result:WrenLoadModuleResult)->Void;
abstract WrenLoadModuleCompleteFn(NativeWrenLoadModuleCompleteFn) {
	@:from
	static inline function fromCallable(f:Callable<HaxeWrenLoadModuleCompleteFn>) {
		return cast f;
	}
}