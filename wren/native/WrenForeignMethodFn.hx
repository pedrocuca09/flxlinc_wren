package wren.native;

import cpp.Star;
import cpp.Callable;

@:native('WrenForeignMethodFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (vm:Star<WrenVM>)->Void;

typedef WrenForeignMethodFnCallable = cpp.Callable<Signature>;
abstract WrenForeignMethodFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenForeignMethodFn {
		return cast v;
	}
}
