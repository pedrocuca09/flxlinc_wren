package wren.native;

import cpp.Star;
import cpp.ConstCharStar;
import cpp.Callable;

@:native('WrenLoadModuleFn')
@:include('linc_wren.h')
private extern class Native {}

private typedef Signature = (vm:Star<WrenVM>, name:ConstCharStar)->WrenLoadModuleResult;

abstract WrenLoadModuleFn(Native) {
	@:from
	static inline function fromCallable(v:Callable<Signature>):WrenLoadModuleFn {
		return cast v;
	}
}
