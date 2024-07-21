package wren;


@:native('WrenFinalizerFn')
@:include('linc_wren.h')
extern class NativeWrenFinalizerFn {}

abstract WrenFinalizerFn(NativeWrenFinalizerFn) {
	@:from
	static inline function fromCallable(f:cpp.Callable<(data:cpp.RawPointer<Void>)->Void>) {
		return cast f;
	}
}