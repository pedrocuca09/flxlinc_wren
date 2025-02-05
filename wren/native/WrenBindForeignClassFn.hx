package wren.native;

import cpp.ConstCharStar;
import cpp.Star;
import cpp.Callable;

@:native('WrenBindForeignClassFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (vm:Star<WrenVM>, module:ConstCharStar, className:ConstCharStar)->WrenForeignClassMethods;

abstract WrenBindForeignClassFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenBindForeignClassFn {
		return cast v;
	}
}
