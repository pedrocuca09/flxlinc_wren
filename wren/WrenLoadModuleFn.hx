package wren;

import wren.WrenVM;
import cpp.Callable;

@:native('WrenLoadModuleFn')
@:include('linc_wren.h')
extern class NativeWrenLoadModuleFn {}

typedef HaxeWrenLoadModuleFn = (vm:RawWrenVM)->Void;
abstract WrenLoadModuleFn(NativeWrenLoadModuleFn) {
	@:from
	static inline function fromCallable(f:Callable<HaxeWrenLoadModuleFn>) {
		return cast f;
	}
}