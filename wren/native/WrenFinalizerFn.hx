package wren.native;

import cpp.Star;
import cpp.Callable;

@:native('WrenFinalizerFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (data:Star<cpp.Void>)->Void;

typedef WrenFinalizerFnCallable = cpp.Callable<Signature>;

abstract WrenFinalizerFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenFinalizerFn {
		return cast v;
	}
}
