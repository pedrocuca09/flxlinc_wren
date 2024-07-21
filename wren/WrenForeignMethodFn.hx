package wren;

import wren.WrenVM;

@:native('WrenForeignMethodFn')
@:include('linc_wren.h')
extern class NativeWrenForeignMethodFn {}
abstract WrenForeignMethodFn(NativeWrenForeignMethodFn) {
	@:from
	static inline function fromCallable(f:cpp.Callable<(vm:RawWrenVM)->Void>) {
		return cast f;
	}
}