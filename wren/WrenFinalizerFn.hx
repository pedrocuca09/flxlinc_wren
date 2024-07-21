package wren;

import cpp.RawPointer;
import cpp.Callable;

@:native('WrenFinalizerFn')
@:include('linc_wren.h')
extern class NativeWrenFinalizerFn {}

typedef HaxeWrenFinalizerFn = (data:RawPointer<Void>)->Void;

abstract WrenFinalizerFn(NativeWrenFinalizerFn) {
	@:from
	static inline function fromCallable(f:Callable<HaxeWrenFinalizerFn>) {
		return cast f;
	}
}