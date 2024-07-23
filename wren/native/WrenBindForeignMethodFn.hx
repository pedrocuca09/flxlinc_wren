package wren.native;

import cpp.Star;
import cpp.ConstCharStar;
import cpp.Callable;

@:native('WrenBindForeignMethodFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (vm:Star<WrenVM>, module:ConstCharStar, className:ConstCharStar, isStatic:Bool, signature:ConstCharStar)->WrenForeignMethodFn;

abstract WrenBindForeignMethodFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenBindForeignMethodFn {
		return cast v;
	}
}
