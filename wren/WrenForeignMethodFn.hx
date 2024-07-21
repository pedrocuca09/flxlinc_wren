package wren;

import wren.WrenVM;
import cpp.Callable;

@:native('WrenForeignMethodFn')
@:include('linc_wren.h')
extern class NativeWrenForeignMethodFn {}

typedef HaxeWrenForeignMethodFn = (vm:RawWrenVM)->Void;
abstract WrenForeignMethodFn(NativeWrenForeignMethodFn) {
	@:from
	static inline function fromCallable(f:Callable<HaxeWrenForeignMethodFn>) {
		return cast f;
	}
}