package wren.native;

import cpp.ConstCharStar;
import cpp.Star;
import cpp.Callable;

@:native('WrenWriteFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (vm:Star<WrenVM>, text:ConstCharStar)->Void;

abstract WrenWriteFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenWriteFn {
		return cast v;
	}
}
